(function () {
  const overlay   = document.getElementById('doc-overlay');
  const frame     = document.getElementById('doc-frame');
  const titleEl   = document.getElementById('doc-title');
  const openLink  = document.getElementById('doc-open-link');
  const closeBtn  = document.getElementById('doc-close-btn');
  const navbar    = document.getElementById('navbar');
  const sidebar   = document.getElementById('sidebar');

  // Only intercept links that point to a local PDF (leave external / http(s) links alone)
  function isLocalPdf(href) {
    if (!href) return false;
    if (/^https?:\/\//i.test(href)) return false;
    return /\.pdf(\?.*)?$/i.test(href);
}

function positionOverlay() {
    const navH = navbar.getBoundingClientRect().height;
    const sidebarIsFixed = getComputedStyle(sidebar).position === 'fixed';
    const sidebarW = sidebarIsFixed ? sidebar.getBoundingClientRect().width : 0;
    overlay.style.top = navH + 'px';
    overlay.style.left = sidebarW + 'px';
}

function openDoc(url, title) {
    positionOverlay();
    frame.src = url;
    titleEl.textContent = title || url;
    openLink.href = url;
    overlay.classList.add('active');
    document.body.style.overflow = 'hidden';
}

function closeDoc() {
    overlay.classList.remove('active');
    frame.src = '';
    document.body.style.overflow = '';
}

  // Delegate clicks: any current or future <a> inside a .table-schedule that links to a local PDF
  document.addEventListener('click', function (e) {
    const link = e.target.closest('.table-schedule a');
    if (!link) return;
    const href = link.getAttribute('href');
    if (!isLocalPdf(href)) return; // let other links (e.g. tutorial .html pages, external URLs) behave normally
    e.preventDefault();
    openDoc(href, link.closest('tr') ? link.closest('tr').children[2].textContent.trim() : link.textContent.trim());
  });

  closeBtn.addEventListener('click', closeDoc);
  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape' && overlay.classList.contains('active')) closeDoc();
  });
  window.addEventListener('resize', function () {
    if (overlay.classList.contains('active')) positionOverlay();
  });
})();