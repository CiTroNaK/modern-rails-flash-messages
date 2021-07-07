import {Controller} from "stimulus"

export default class extends Controller {
  static targets = ["buttons", "countdown"]

  connect() {
    const timeoutSeconds = parseInt(this.data.get("timeout"));

    setTimeout(() => {
      this.element.classList.remove('hidden');
      this.element.classList.add('notification-enter', 'notification-enter-from');

      // Trigger transition
      setTimeout(() => {
        this.element.classList.add('notification-enter-to');
      }, 100);

      // Trigger countdown
      if (this.hasCountdownTarget) {
        this.countdownTarget.style.animation = 'notification-countdown linear ' + timeoutSeconds + 's';
      }

    }, 500);
    this.timeoutId = setTimeout(() => {
      this.close();
    }, timeoutSeconds * 1000 + 500);
  }

  run(e) {
    e.preventDefault();
    this.stop();
    let _this = this;
    this.buttonsTarget.innerHTML = '<span class="text-sm leading-5 font-medium text-grey-700">Processing...</span>';

    // Call the action
    fetch(this.data.get("action-url"), {
      method: this.data.get("action-method").toUpperCase(),
      dataType: 'script',
      credentials: "include",
      headers: {
        "X-CSRF-Token": this.csrfToken
      },
    })
      .then(response => {
        if (!response.ok) {
          throw Error(response.statusText);
        }
        return response;
      })
      .then(response => response.json())
      .then(data => {
        // Set new content
        _this.buttonsTarget.innerHTML = '<span class="text-sm leading-5 font-medium text-green-700">' + data.message + '</span>';

        // Remove hidden class and display the record
        if (data.inline) {
          document.getElementById(data.dom_id).classList.toggle('hidden');
        }

        // Close
        setTimeout(() => {
          if (data.inline) {
            // Just close the notification
            _this.close();
          } else {
            // Reload the page using Turbo
            window.Turbo.visit(window.location.toString(), {action: 'replace'})
          }
        }, 1000);
      })
      .catch(error => {
        console.log(error);
        _this.buttonsTarget.innerHTML = '<span class="text-sm leading-5 font-medium text-red-700">Error!</span>';
        setTimeout(() => {
          _this.close();
        }, 1000);
      });
  }

  stop() {
    clearTimeout(this.timeoutId)
    this.timeoutId = null
  }

  continue() {
    this.timeoutId = setTimeout(() => {
      this.close();
    }, parseInt(this.data.get("timeout")));
  }

  close() {
    this.element.classList.remove('notification-enter', 'notification-enter-from', 'notification-enter-to');
    this.element.classList.add('notification-leave', 'notification-leave-from')

    // Trigger transition
    setTimeout(() => {
      this.element.classList.add('notification-leave-to');
    }, 100);

    // Remove element after transition
    setTimeout(() => {
      this.element.remove();
    }, 300);
  }

  get csrfToken() {
    const element = document.head.querySelector('meta[name="csrf-token"]')
    return element.getAttribute("content")
  }
}
