import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="insert-in-list"
export default class extends Controller {
  static targets = ["songs", "form"]

  connect() {
    this.csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute("content")
  }

  send(event) {
    event.preventDefault()
    const url = this.formTarget.action
    const options = {
      method: 'POST',
      headers: { "Accept": "application/json", "X-CSRF-Token": this.csrfToken },
      body: new FormData(this.formTarget)
    }
    fetch(url, options)
      .then(response => response.json())
      .then((data) => {
        console.log('data', data)
        debugger
        if (data.inserted_lsong) {
          console.log('Insert-in-List did the trick !');
          this.songsTarget.insertAdjacentHTML("beforeend", data.inserted_lsong)
        } else if (data.empty) {
          alert("You need To Choose a Song and a tonality!")
          // location.reload()
        } else {
          console.log('Insert-in-List said: "that was not me"')
        }
        console.log(data.inserted_lsong)
      this.formTarget.outerHTML = data.form
    })
  }
}
