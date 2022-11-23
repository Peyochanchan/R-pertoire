import { Controller } from "@hotwired/stimulus"
import Sortable from 'sortablejs'

export default class extends Controller {
  static targets = [ "position" ]

  connect() {
    this.sortable = Sortable.create(this.element, {
      group: 'shared',
      animation: 150,
      onEnd: this.end.bind(this)
    })
  }

  end(event) {
    let id = event.item.dataset.id
    let list_id = event.item.dataset.listId
    let data = new FormData()
    data.append("position", event.newIndex + 1)
    let url = this.data.get("url")
    let mapUrl = { list_id: list_id, id: id}
    url = url.replace(/list_id|id/gi, function(matched){
      return mapUrl[matched];
    })

    Rails.ajax({
      url: url,
      type: 'PATCH',
      data: data
    })
    this.positionTargets.forEach((pos,i) => {
      pos.innerText = i + 1;
    });
  }
}
