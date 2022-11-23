import { Controller } from "@hotwired/stimulus"
import Reveal from 'stimulus-reveal-controller'

// Connects to data-controller="reveal"
export default class extends Controller {
  static targets = ["item_description",
                    "item_name",
                    "item_lyrics",
                    "item_title",
                    "description",
                    "name",
                    "lyrics",
                    "title",
                    "checkbox_description",
                    "checkbox_name",
                    "checkbox_lyrics",
                    "checkbox_title"]

  connect() {
    // console.log('say hello')
    // this.toggleForm(this.item_nameTarget, this.nameTargets, this.checkbox_nameTarget)
  }

  toggleLyrics() {
    this.toggleForm(this.item_lyricsTarget, this.lyricsTargets, this.checkbox_lyricsTarget)
  }

  toggleTitle() {
    this.toggleForm(this.item_titleTarget, this.titleTargets, this.checkbox_titleTarget)

  }

  toggleName() {
    this.toggleForm(this.item_nameTarget, this.nameTargets, this.checkbox_nameTarget)
  }

  toggleDescription() {
    this.toggleForm(this.item_descriptionTarget, this.descriptionTargets, this.checkbox_descriptionTarget)
  }

  toggleForm(item, input_form, checkbox) {
    if(checkbox.checked) {
      input_form.forEach(i => i.disabled = true)
    } else if(!checkbox.checked) {
      input_form.forEach(i => i.disabled = false)
    }
    item.classList.toggle('hidden')
  console.log('checked?', checkbox.checked)
  input_form.forEach(input => console.log('disabled?', input.disabled))
  }
}
