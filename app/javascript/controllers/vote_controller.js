import { Controller } from 'stimulus'
import Rails from '@rails/ujs'
import { Modal, Tooltip } from 'bootstrap'

export default class extends Controller {
  static targets = ['button', 'buttonText', 'count', 'iconList', 'icon', 'iconTemplate']

  initialize () {
    this.element.querySelectorAll('[data-toggle="tooltip"]').forEach(tooltipElement => {
      new Tooltip(tooltipElement)
    })
    if (this.hasButtonTarget) {
      this.updateButton()
    }
  }

  async toggle () {
    try {
      if (this.isVoted) {
        await this.request('DELETE')
        this.isVoted = false
        this.voteCount--
        this.removeIcon()
      } else {
        await this.request('POST')
        this.isVoted = true
        this.voteCount++
        this.addIcon()
      }
    } catch (error) {
      const errorModal = document.getElementById('modal-error')
      errorModal.querySelector('.modal-body').innerHTML = `<p>${error.message}</p>`
      new Modal(errorModal).show()
    }
  }

  get isVoted () {
    return this.data.get('voted') === 'true'
  }

  set isVoted (voted) {
    this.data.set('voted', voted)
    this.updateButton()
  }

  get voteCount () {
    return parseInt(this.countTarget.textContent)
  }

  set voteCount (value) {
    this.countTarget.textContent = value
  }

  request (method) {
    this.buttonTarget.disabled = true
    return fetch(this.data.get('endpoint'), {
      method: method,
      credentials: 'same-origin',
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': Rails.csrfToken(),
      }
    }).then(response => {
      if (response.ok) {
        return Promise.resolve()
      } else {
        return response.json().then(body => {
          return Promise.reject(new Error(body.errors.join('<br>')))
        })
      }
    }).finally(() => {
      this.buttonTarget.disabled = false
    })
  }

  updateButton () {
    if (this.isVoted) {
      this.buttonTarget.classList.toggle('active', true)
      this.buttonTextTarget.textContent = '取り消す'
    } else {
      this.buttonTarget.classList.toggle('active', false)
      this.buttonTextTarget.textContent = '投票する'
    }
  }

  addIcon () {
    const icon = document.importNode(this.iconTemplateTarget.content, true)
    icon.firstElementChild.dataset.target = 'vote.icon'
    new Tooltip(icon.querySelector('[data-toggle="tooltip"]'))
    this.iconListTarget.appendChild(icon)
  }

  removeIcon () {
    this.iconTarget.remove()
  }
}
