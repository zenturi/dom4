/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is dom4 code.
 *
 * The Initial Developer of the Original Code is
 * Disruptive Innovations SAS
 * Portions created by the Initial Developer are Copyright (C) 2014
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *   Daniel Glazman <daniel.glazman@disruptive-innovations.com>
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either of the GNU General Public License Version 2 or later (the "GPL"),
 * or the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */


package dom4;

class Node extends EventTarget {

  /*
   * https://dom.spec.whatwg.org/#interface-node
   */

  public static inline var ELEMENT_NODE: Int = 1;
  public static inline var ATTRIBUTE_NODE: Int = 2;
  public static inline var TEXT_NODE: Int = 3;
  public static inline var CDATA_SECTION_NODE: Int = 4;
  public static inline var ENTITY_REFERENCE_NODE: Int = 5;
  public static inline var ENTITY_NODE: Int = 6;
  public static inline var PROCESSING_INSTRUCTION_NODE: Int = 7;
  public static inline var COMMENT_NODE: Int = 8;
  public static inline var DOCUMENT_NODE: Int = 9;
  public static inline var DOCUMENT_TYPE_NODE: Int = 10;
  public static inline var DOCUMENT_FRAGMENT_NODE: Int = 11;
  public static inline var NOTATION_NODE: Int = 12;

  public static inline var DOCUMENT_POSITION_DISCONNECTED: Int = 0x01;
  public static inline var DOCUMENT_POSITION_PRECEDING: Int = 0x02;
  public static inline var DOCUMENT_POSITION_FOLLOWING: Int = 0x04;
  public static inline var DOCUMENT_POSITION_CONTAINS: Int = 0x08;
  public static inline var DOCUMENT_POSITION_CONTAINED_BY: Int = 0x10;
  public static inline var DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC: Int = 0x20;

  /*
   * https://dom.spec.whatwg.org/#dom-node-nodetype
   */
  public var nodeType(default, null): Int;

  /*
   * https://dom.spec.whatwg.org/#dom-node-nodename
   */
  public var nodeName(get, null): DOMString;
      private function get_nodeName(): DOMString
      {
        return switch (this.nodeType)
        {
          case ELEMENT_NODE: cast(this, Element).tagName;
          case TEXT_NODE: "#text";
          case PROCESSING_INSTRUCTION_NODE: cast(this, ProcessingInstruction).target;
          case COMMENT_NODE: "#comment";
          case DOCUMENT_NODE: "#document";
          case DOCUMENT_TYPE_NODE: cast(this, DocumentType).name;
          case DOCUMENT_FRAGMENT_NODE: "#document-fragment";
          case _: ""; // should never hit
        } 
      }

  /*
   * https://dom.spec.whatwg.org/#dom-node-baseuri
   */
  public var baseURI(default, null): DOMString;

  /*
   * https://dom.spec.whatwg.org/#dom-node-ownerdocument
   */
  public var ownerDocument(default, null): Document;

  /*
   * https://dom.spec.whatwg.org/#dom-node-parentnode
   */
  public var parentNode(default, null): Node;

  /*
   * https://dom.spec.whatwg.org/#dom-node-parentelement
   */
  public var parentElement(get, null): Element;
      private function get_parentElement() : Element
      {
        return ((this.parentNode.nodeType == ELEMENT_NODE)
                ? cast(this.parentNode, Element)
                : null);
      }

  /*
   * https://dom.spec.whatwg.org/#dom-node-haschildnodes
   */
  public function hasChildNodes(): Bool
  {
    return (null != this.firstChild);
  }

  /*
   * https://dom.spec.whatwg.org/#dom-node-childnodes
   */
  public var childNodes(get, null): NodeList;
      private function get_childNodes(): NodeList
      {
        return new NodeList(this.firstChild);
      }

  /*
   * https://dom.spec.whatwg.org/#dom-node-firstchild
   */
  public var firstChild(default, null): Node;

  /*
   * https://dom.spec.whatwg.org/#dom-node-lastchild
   */
  public var lastChild(default, null): Node;

  /*
   * https://dom.spec.whatwg.org/#dom-node-previoussibling
   */
  public var previousSibling(default, null): Node;

  /*
   * https://dom.spec.whatwg.org/#dom-node-nextsibling
   */
  public var nextSibling(default, null): Node;

  /*
   * https://dom.spec.whatwg.org/#dom-node-nodevalue
   */
  public var nodeValue(get, set): DOMString;
      private function get_nodeValue(): DOMString
      {
        switch (this.nodeType) {
          case TEXT_NODE | PROCESSING_INSTRUCTION_NODE | COMMENT_NODE:
            return cast(this, CharacterData).data;
          case _:
            return null;
        }
      }
      private function set_nodeValue(v: DOMString): DOMString
      {
        switch (this.nodeType) {
          case TEXT_NODE | PROCESSING_INSTRUCTION_NODE | COMMENT_NODE:
            cast(this, CharacterData).data = v;
        }
        return v;
      }

  /*
   * https://dom.spec.whatwg.org/#dom-node-textcontent
   */
  public var textContent(get, set): DOMString;
      private function get_textContent(): DOMString
      {
        var rv = this.nodeValue;
        if (rv == null) {
          rv = "";
          var n = this.firstChild;
          while (n != null) {
            rv += n.textContent;
            n = n.nextSibling;
          }
        }
        return rv;
      }
      private function set_textContent(v: DOMString): DOMString
      {
        switch (this.nodeType) {
          case TEXT_NODE | PROCESSING_INSTRUCTION_NODE | COMMENT_NODE:
            cast(this, CharacterData).data = v;
          case ELEMENT_NODE: {
            this.firstChild = new Text(v);
            this.lastChild = this.firstChild;
          }
          case _:{}
        }
        return v;
      }

  /*
   * https://dom.spec.whatwg.org/#dom-node-normalize
   */
  public function normalize(): Void
  {
    var node = this.firstChild;
    while (node != null) {
      switch (node.nodeType) {
        case TEXT_NODE: {
          while (node.nextSibling != null && node.nextSibling.nodeType == TEXT_NODE) {
            cast(node, Text).data += cast(node.nextSibling, Text).data;
            node.parentNode.removeChild(node.nextSibling);
          }
        }
        case ELEMENT_NODE: node.normalize();
      }
      node = node.nextSibling;
    }
  }

  /*
   * https://dom.spec.whatwg.org/#dom-node-clonenode
   */
  public function cloneNode(?deep: Bool = false) : Node
  {
    // XXX
    return null;
  }

  private function _cloneOneNode() : Node
  {
    switch (this.nodeType) {
      case DOCUMENT_TYPE_NODE: {
        var dt = cast(this, DocumentType);
        return cast(this.ownerDocument.implementation.createDocumentType(dt.name, dt.publicId, dt.systemId), Node);
      }
      case TEXT_NODE:
        return cast(this.ownerDocument.createTextNode(cast(this, Text).data), Node);
      case COMMENT_NODE:
        return cast(this.ownerDocument.createComment(cast(this, Comment).data), Node);
      case PROCESSING_INSTRUCTION_NODE: {
        var pi = cast(this, ProcessingInstruction);
        return cast(this.ownerDocument.createProcessingInstruction(pi.target, pi.data), Node);
      }
      case ELEMENT_NODE: {
        var e = cast(this, Element);
        var newElt = this.ownerDocument.createElementNS(e.namespaceURI, e.localName);
      }
    }
    return null; // should never happen
  }

  /*
   * https://dom.spec.whatwg.org/#dom-node-isequalnode
   */
  public function isEqualNode(node: Node): Bool
  {
    // XXX must run in depth
    return (node == this);
  }

  /* 
   * https://dom.spec.whatwg.org/#dom-node-comparedocumentposition
   */
  public function compareDocumentPosition(other: Node): Int
  {
    if (this == other)
      return 0;

    var referenceRoot = this;
    var referenceAncestors: Array<Node> = [];
    while (referenceRoot.parentNode != null
           && (referenceRoot.parentNode.nodeType == ELEMENT_NODE
               ||  referenceRoot.parentNode.nodeType == TEXT_NODE
               ||  referenceRoot.parentNode.nodeType == COMMENT_NODE
               ||  referenceRoot.parentNode.nodeType == PROCESSING_INSTRUCTION_NODE)) {
      referenceRoot = referenceRoot.parentNode;
      referenceAncestors.push(referenceRoot);
      if (referenceRoot == other)
        return DOCUMENT_POSITION_CONTAINS | DOCUMENT_POSITION_PRECEDING;
    }

    var otherRoot = other;
    var otherAncestors: Array<Node> = [];
    while (otherRoot.parentNode != null
           && (otherRoot.parentNode.nodeType == ELEMENT_NODE
               ||  otherRoot.parentNode.nodeType == TEXT_NODE
               ||  otherRoot.parentNode.nodeType == COMMENT_NODE
               ||  otherRoot.parentNode.nodeType == PROCESSING_INSTRUCTION_NODE)) {
      otherRoot = otherRoot.parentNode;
      otherAncestors.push(otherRoot);
      if (otherRoot == this)
        return  DOCUMENT_POSITION_CONTAINED_BY | DOCUMENT_POSITION_FOLLOWING;
    }

    if (referenceRoot != otherRoot)
      return  DOCUMENT_POSITION_DISCONNECTED
              | DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC
              | DOCUMENT_POSITION_PRECEDING;

    // find deepest common ancestor
    var index = 0;
    var commonAncestor: Node = null;
    while (index < Math.min(referenceAncestors.length, otherAncestors.length)) {
      if (referenceAncestors[index] == otherAncestors[index])
        commonAncestor = referenceAncestors[index];
    }

    // there _is_ a common ancestor because they belong to same tree
    var node: Node = commonAncestor;
    while (true) {
      if (node == other)
        return DOCUMENT_POSITION_PRECEDING;
      if (node == this)
        return DOCUMENT_POSITION_FOLLOWING;

      if (null != node.firstChild) {
        node = node.firstChild;
      }
      else if (null != node.nextSibling)
        node = node.nextSibling;
      else if (null == node.parentNode)
        break;
      else {
        while (null == node.nextSibling
               && null != node.parentNode
               && node.parentNode.nodeType == Node.ELEMENT_NODE) {
          node = node.parentNode;
        }
        node = node.nextSibling;
        if (null == node)
          break;
      }
    }

    // sanity case
    throw (new DOMException("ShouldNeverHitError"));
  }

  /*
   * https://dom.spec.whatwg.org/#dom-node-contains
   */
  public function contains(other: Node): Bool
  {
    if (this.isEqualNode(other))
      return true;
    var node = this.firstChild;
    while (node != null) {
      if (node.isEqualNode(other))
        return true;
      node = node.nextSibling;
    }
    return false;
  }

  /*
   * https://dom.spec.whatwg.org/#dom-node-insertbefore
   */
  public function insertBefore(node: Node, child: Node): Node {
    switch (this.nodeType) {
      case DOCUMENT_NODE
           | DOCUMENT_FRAGMENT_NODE
           | ELEMENT_NODE: {}
      case _: throw (new DOMException("Hierarchy request error "));
    }

    if (child != null && child.parentNode != this)
      throw (new DOMException("Not found error"));

    switch (node.nodeType) {
      case DOCUMENT_FRAGMENT_NODE
           | DOCUMENT_TYPE_NODE
           | ELEMENT_NODE
           | TEXT_NODE
           | PROCESSING_INSTRUCTION_NODE
           | COMMENT_NODE: {}
      case _: throw (new DOMException("Hierarchy request error"));
    }

    if ((node.nodeType == TEXT_NODE && this.nodeType == DOCUMENT_NODE)
        || (node.nodeType == DOCUMENT_TYPE_NODE && this.nodeType != DOCUMENT_NODE))
      throw (new DOMException("Hierarchy request error"));

    if (this.nodeType == DOCUMENT_NODE) {
      if (node.nodeType == DOCUMENT_FRAGMENT_NODE) {
        var n = cast(node, ParentNode);
        if (n.firstElementChild != null && n.firstElementChild != n.lastElementChild)
          throw (new DOMException("Hierarchy request error"));
        var currentNode = node.firstChild;
        while (currentNode != null) {
          if (currentNode.nodeType == TEXT_NODE)
            throw (new DOMException("Hierarchy request error"));
          currentNode = child.nextSibling;
        }

        if (n.firstElementChild != null
            && (cast(this, ParentNode).firstElementChild != null
                || (child != null && child.nodeType == DOCUMENT_TYPE_NODE)
                || (child != null && child.nextSibling != null && child.nextSibling.nodeType == DOCUMENT_TYPE_NODE)))
          throw (new DOMException("Hierarchy request error"));
      }
      else if (node.nodeType == ELEMENT_NODE) {
        if (cast(this, ParentNode).firstElementChild != null
            || (child != null && child.nodeType == DOCUMENT_TYPE_NODE)
            || (child != null && child.nextSibling != null && child.nextSibling.nodeType == DOCUMENT_TYPE_NODE))
          throw (new DOMException("Hierarchy request error"));
      }
      else if (node.nodeType == DOCUMENT_TYPE_NODE) {
        var currentNode = this.firstChild;
        var foundDoctypeInParent = false;
        while (!foundDoctypeInParent && child != null) {
          if (currentNode.nodeType == DOCUMENT_TYPE_NODE)
            foundDoctypeInParent = true;
          currentNode = currentNode.nextSibling;
        }
        if (foundDoctypeInParent
            || (child != null && cast(child, NonDocumentTypeChildNode).previousElementSibling != null)
            || (child == null && cast(child, ParentNode).firstElementChild != null))
          throw (new DOMException("Hierarchy request error"));
      }
    }

    var referenceChild = child;
    if (referenceChild == node) {
      referenceChild = node.nextSibling;
    }

    if (this.nodeType == DOCUMENT_NODE)
      cast(this, Document).adoptNode(node);
    else
      this.ownerDocument.adoptNode(node);

    function _doInsertBefore(n: Node) {
      if (null != referenceChild) {
        n.previousSibling = referenceChild.previousSibling;
        referenceChild.previousSibling = n;
      }
      else {
        n.previousSibling = this.lastChild;
        this.lastChild = n;
      }
      if (null != n.previousSibling) {
        n.previousSibling.nextSibling = n;
      }
      else {
        this.firstChild = n;
      }
      n.parentNode = this;
    }

    node.nextSibling = referenceChild;
    if (node.nodeType == DOCUMENT_FRAGMENT_NODE) {
      while (node.firstChild != null) {
        var f = node.firstChild;
        node.removeChild(f);
        _doInsertBefore(f);
      }
    }
    else {
        _doInsertBefore(node);
    }

    return node;
  }

  /*
   * https://dom.spec.whatwg.org/#dom-node-appendchild
   */
  public function appendChild(node: Node): Node
  {
    return this.insertBefore(node, null);
  }

  /*
   * https://dom.spec.whatwg.org/#dom-node-removechild
   */
  public function removeChild(child: Node): Node
  {
    if (child == null || child.parentNode == null)
      throw (new DOMException("Hierarchy request error"));

    if (child.parentNode != this)
      throw (new DOMException("Not found error"));

    var parent = child.parentNode;
    if (child.previousSibling != null)
      child.previousSibling.nextSibling = child.nextSibling;
    if (child.nextSibling != null)
      child.nextSibling.previousSibling = child.previousSibling;
    if (parent.firstChild == child)
      parent.firstChild = child.nextSibling;
    if (parent.lastChild == child)
      parent.lastChild = null;

    Document._setNodeOwnerDocument(child, null);
    return child;
  }

  /*
   * https://dom.spec.whatwg.org/#dom-node-replacechild
   */
  public function replaceChild(node: Node, child: Node): Node
  {
    switch (this.nodeType) {
      case DOCUMENT_NODE
           | DOCUMENT_FRAGMENT_NODE
           | ELEMENT_NODE: {}
      case _: throw (new DOMException("Hierarchy request error "));
    }

    if (child != null && child.parentNode != this)
      throw (new DOMException("Not found error"));

    switch (node.nodeType) {
      case DOCUMENT_FRAGMENT_NODE
           | DOCUMENT_TYPE_NODE
           | ELEMENT_NODE
           | TEXT_NODE
           | PROCESSING_INSTRUCTION_NODE
           | COMMENT_NODE: {}
      case _: throw (new DOMException("Hierarchy request error"));
    }

    if ((node.nodeType == TEXT_NODE && this.nodeType == DOCUMENT_NODE)
        || (node.nodeType == DOCUMENT_TYPE_NODE && this.nodeType != DOCUMENT_NODE))
      throw (new DOMException("Hierarchy request error"));

    var t = cast(this, ParentNode);
    if (this.nodeType == DOCUMENT_NODE) {
      if (node.nodeType == DOCUMENT_FRAGMENT_NODE) {
        var n = cast(node, ParentNode);
        if (n.firstElementChild != null && n.firstElementChild != n.lastElementChild)
          throw (new DOMException("Hierarchy request error"));
        var currentNode = node.firstChild;
        while (currentNode != null) {
          if (currentNode.nodeType == TEXT_NODE)
            throw (new DOMException("Hierarchy request error"));
          currentNode = child.nextSibling;
        }

        if (n.firstElementChild != null
            && ((t.firstElementChild != null && t.firstElementChild != child)
                || (child.nextSibling != null && child.nextSibling.nodeType == DOCUMENT_TYPE_NODE)))
          throw (new DOMException("Hierarchy request error"));
      }
      else if (node.nodeType == ELEMENT_NODE) {
        if ((t.firstElementChild != null && t.firstElementChild != child)
            || (child.nextSibling != null && child.nextSibling.nodeType == DOCUMENT_TYPE_NODE))
          throw (new DOMException("Hierarchy request error"));
      }
      else if (node.nodeType == DOCUMENT_TYPE_NODE) {
        var currentNode = this.firstChild;
        var foundDoctypeInParent = false;
        while (!foundDoctypeInParent && child != null) {
          if (currentNode.nodeType == DOCUMENT_TYPE_NODE && currentNode != child)
            foundDoctypeInParent = true;
          currentNode = currentNode.nextSibling;
        }
        if (foundDoctypeInParent
            || (child == null && cast(child, ParentNode) != null && cast(child, ParentNode).firstElementChild != null))
          throw (new DOMException("Hierarchy request error"));
      }
    }

    var reference = child.nextSibling;
    if (reference == node)
      reference = node.nextSibling;

    if (this.nodeType == DOCUMENT_NODE)
      cast(this, Document).adoptNode(node);
    else
      this.ownerDocument.adoptNode(node);
    this.removeChild(child);
    this.insertBefore(node, reference);
    return child;
  }

  public function new() {
    super();
  }
}
