import { Controller } from '@hotwired/stimulus';

export default class extends Controller {

  connect() {
  }

  addClass() {
    this.element.classList.add(this.className);
  }

  removeClass() {
    this.element.classList.remove(this.className);
  }

  toggleClass() {
    console.log('Im toggling, but nothing for the moment', this.element)
    this.element.classList.toggle(this.className);
  }

  get className() {
    const className = this.data.get("class");
    if (!className) {
      throw new Error(`Missing "data-${this.identifier}-class" attribute`);
    }
    return className;
  }
}
