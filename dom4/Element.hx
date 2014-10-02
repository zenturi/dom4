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

class Element extends ParentNode {

  /*
   * https://dom.spec.whatwg.org/#interface-element
   */

  /*
   * https://dom.spec.whatwg.org/#dom-element-namespaceuri
   */
  public var namespaceURI(default, null): DOMString;

  /*
   * https://dom.spec.whatwg.org/#dom-element-prefix
   */
  public var prefix(default, null): DOMString;

  /*
   * https://dom.spec.whatwg.org/#dom-element-localname
   */
  public var localName(default, null): DOMString;

  /*
   * https://dom.spec.whatwg.org/#dom-element-tagname
   */
  public var tagName(get, null): DOMString;
      private function get_tagName(): DOMString
      {
        var qualifiedName = this.localName;
        if (this.prefix != "")
          qualifiedName = this.prefix + ":" + this.localName;
        if (this.namespaceURI == DOMImplementation.HTML_NAMESPACE
            && this.ownerDocument.documentElement != null
            && this.ownerDocument.documentElement.localName.toLowerCase() == "html")
          qualifiedName = qualifiedName.toUpperCase();
        return qualifiedName;
      }

  /*
   * https://dom.spec.whatwg.org/#dom-element-id
   * XXX
   */
  public var id: DOMString;

  /*
   * https://dom.spec.whatwg.org/#dom-element-classname
   */
  public var className: DOMString;
      private function get_className(): DOMString
      {
        return this.classList.toString();
      }
      private function set_className(v: DOMString): DOMString
      {
        this.classList = new DOMTokenList(v);
        return this.classList.toString();
      }

  /*
   * https://dom.spec.whatwg.org/#dom-element-classlist
   */
  public var classList(default, null): DOMTokenList;

  public function new(namespace: DOMString, localName: DOMString, ?prefix: DOMString = "") {
    super();
    this.namespaceURI = namespace;
    this.localName = localName;
    this.prefix = prefix;
  }
}
