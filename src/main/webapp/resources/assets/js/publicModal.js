(function() {
  // 알럿 모달 유틸리티
const publicModals = {
  show: (message, options = {}) => {
    const {
      confirmText = '확인',
      cancelText = null,
      onConfirm = null,
      onCancel = null,
      size_x = null,
      size_y = null
    } = options;

    const overlay = document.getElementById('publicModalOverlay');
    const modal = document.getElementById('publicModal');
    const messageEl = modal.querySelector('.public-modal-message');
    const buttonsEl = modal.querySelector('.public-modal-buttons');

    if (size_x) {
      modal.style.width = size_x;
    } else {
      modal.style.removeProperty('width');
    }
    
    if (size_y) {
      modal.style.height = size_y;
    } else {
      modal.style.removeProperty('height');
    }

    messageEl.innerHTML = message;
    
    let buttonsHTML = '';
    if (cancelText) {
      buttonsHTML += `<button class="public-modal-button cancel">${cancelText}</button>`;
    }
    buttonsHTML += `<button class="public-modal-button confirm">${confirmText}</button>`;
    
    buttonsEl.innerHTML = buttonsHTML;

    overlay.style.display = 'block';
    modal.style.display = 'block';

    const confirmBtn = modal.querySelector('.public-modal-button.confirm');
    const cancelBtn = modal.querySelector('.public-modal-button.cancel');

    confirmBtn.onclick = () => {
    
      if (onConfirm) {
        const result = onConfirm();
	    if (result === false) {
	      return; // false 리턴 시 모달 닫지 않음
	    }
      };
      publicModals.hide();
    };

    if (cancelBtn) {
      cancelBtn.onclick = () => {
        if (onCancel) onCancel();
        publicModals.hide();
      };
    }
  },
  hide: () => {
    document.getElementById('publicModalOverlay').style.display = 'none';
    document.getElementById('publicModal').style.display = 'none';
  }
};

window.publicModals = publicModals;
})();