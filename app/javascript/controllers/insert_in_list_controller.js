import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="insert-in-list"
export default class extends Controller {
  static targets = ["items"]

  connect() {
    console.log(this.element)
  }

  send(event) {
    event.preventDefault()
    const form = event.target
    const list = this.itemsTarget
    const url = form.action

    fetch(url, {
      method: "POST",
      headers: { "Accept": "application/json"},
      body: new FormData(form)
    })
    .then(response => response.json())
    .then(data => {
      if (data.review_html) {
        this.itemsTarget.insertAdjacentHTML('beforeend', data.review_html)
      }
      form.outerHTML = data.form_html
    })
  }
}
