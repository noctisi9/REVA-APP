// Global scroll nav
const nav = document.getElementById('topNav');
if (nav) {
    window.addEventListener('scroll', () => nav.classList.toggle('scrolled', window.scrollY > 40));
}

// Global intersection observer for reveals
const io = new IntersectionObserver(entries => entries.forEach(e => {
    if (e.isIntersecting) e.target.classList.add('visible');
}), { threshold: 0.08 });
document.querySelectorAll('.reveal, .reveal-card').forEach(r => io.observe(r));

// Modal functionality for video cards (discovery and healing pages)
const modal = document.getElementById('videoModal');
const iframe = document.getElementById('modalIframe');
if (modal && iframe) {
    document.querySelectorAll('.video-card').forEach(card => {
        card.addEventListener('click', () => {
            document.getElementById('modalTitle').textContent = card.dataset.title;
            document.getElementById('modalDesc').textContent = card.dataset.desc;
            const yt = card.dataset.yt;
            if (yt) {
                iframe.src = `https://www.youtube.com/embed/${yt}?autoplay=1`;
                iframe.srcdoc = '';
            } else {
                iframe.src = '';
                iframe.srcdoc = `<div style="width:100%;height:100%;display:flex;align-items:center;justify-content:center;background:#0A1E3F;color:#B2E0F4;font-family:sans-serif;flex-direction:column;gap:14px;"><span style="font-size:52px">🎬</span><span style="font-size:15px;font-weight:700;">Video coming soon</span><span style="opacity:0.6;font-size:12px;text-align:center;padding:0 20px;">Add your YouTube video ID to the data-yt attribute on this card</span></div>`;
            }
            modal.classList.add('open');
            document.body.style.overflow = 'hidden';
        });
    });

    function closeModal() {
        modal.classList.remove('open');
        iframe.src = '';
        iframe.srcdoc = '';
        document.body.style.overflow = '';
    }

    document.getElementById('modalClose').addEventListener('click', closeModal);
    modal.addEventListener('click', e => { if (e.target === modal) closeModal(); });
    document.addEventListener('keydown', e => { if (e.key === 'Escape') closeModal(); });
}

// Ripple on FB buttons (community page)
[document.getElementById('heroFbBtn'), document.getElementById('mainFbBtn')].forEach(btn => {
    if (!btn) return;
    btn.addEventListener('click', function(e) {
        const rect = this.getBoundingClientRect();
        const r = document.createElement('span');
        r.className = 'ripple-click';
        const size = Math.max(rect.width, rect.height);
        r.style.cssText = `width:${size}px;height:${size}px;left:${e.clientX - rect.left - size/2}px;top:${e.clientY - rect.top - size/2}px;`;
        this.appendChild(r);
        setTimeout(() => r.remove(), 700);
    });
});

// Ripple effect on all styled buttons (index page)
document.querySelectorAll(
    '.reva-header .join-us, .hero-text-block .join-us, ' +
    '.play-video, .view-more-btn, .nav-arrow, .browse-btn'
).forEach(function(btn) {
    if (!btn) return;
    btn.addEventListener('click', function(e) {
        var rect = btn.getBoundingClientRect();
        var span = document.createElement('span');
        var size = Math.max(rect.width, rect.height);
        span.className = 'btn-ripple';
        span.style.cssText =
            'width:' + size + 'px;' +
            'height:' + size + 'px;' +
            'left:' + (e.clientX - rect.left - size / 2) + 'px;' +
            'top:' + (e.clientY - rect.top - size / 2) + 'px;' +
            'background: rgba(255,255,255,0.25);';
        btn.appendChild(span);
        setTimeout(function() { span.remove(); }, 600);
    });
});
// Mobile nav toggle (hamburger)
document.querySelectorAll('.nav-toggle').forEach(btn => {
    btn.addEventListener('click', () => {
        const bar = btn.closest('.top-nav');
        const links = bar && bar.querySelector('.nav-links');
        if (links) links.classList.toggle('open');
    });
});

// Cookie consent banner — shown until the visitor acknowledges it.
// See privacy.html / cookies.html for what's actually collected.
(function () {
    const KEY = 'reva_cookie_consent_ack';
    if (localStorage.getItem(KEY)) return;

    const banner = document.createElement('div');
    banner.id = 'cookie-banner';
    banner.innerHTML =
        '<p>REVA uses essential cookies/local storage to keep you signed in. ' +
        'See our <a href="cookies.html">Cookies Policy</a> for details.</p>' +
        '<button id="cookie-ack-btn">Got it</button>';
    document.body.appendChild(banner);
    requestAnimationFrame(() => banner.classList.add('show'));

    document.getElementById('cookie-ack-btn').addEventListener('click', () => {
        localStorage.setItem(KEY, '1');
        banner.classList.remove('show');
        setTimeout(() => banner.remove(), 400);
    });
})();
