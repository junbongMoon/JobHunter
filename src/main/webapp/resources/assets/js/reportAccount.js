window.onload = () => {
  document.querySelectorAll('.flagAccBtn').forEach(e => {
    e.innerHTML = `<i class="bi bi-exclamation-circle" style="color:red; margin:0px 0.3em"></i>`;
    
    e.setAttribute('title', '해당 사용자를 신고하시겠습니까?');
    
    new bootstrap.Tooltip(e);
    
    e.addEventListener('click', function () {
      const uid = this.dataset.uid;
      const type = this.dataset.type;
      console.log(uid);
    });
  });
}