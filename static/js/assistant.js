(function () {
    // استخراج پارامتر از URL اسکریپت
    const scriptSrc = document.currentScript.src;
    const urlParams = new URL(scriptSrc).searchParams;
    const assistantId = urlParams.get('assistant_id');

    if (!assistantId) return;

    const iframeSrc = `https://shetabito.ir/iframe/assistant/${assistantId}`;

    // ساخت باکس چت شناور
    const widgetContainer = document.createElement('div');
    widgetContainer.id = 'chatWidgetContainer';
    widgetContainer.style.position = 'fixed';
    widgetContainer.style.bottom = '20px';
    widgetContainer.style.right = '20px';
    widgetContainer.style.zIndex = '9999';

    const toggleBtn = document.createElement('div');
    toggleBtn.id = 'chatToggleBtn';
    toggleBtn.style.width = '50px';
    toggleBtn.style.height = '50px';
    toggleBtn.style.borderRadius = '50%';
    toggleBtn.style.background = 'linear-gradient(135deg, #4285F4, #34A853)';
    toggleBtn.style.display = 'flex';
    toggleBtn.style.alignItems = 'center';
    toggleBtn.style.justifyContent = 'center';
    toggleBtn.style.cursor = 'pointer';
    toggleBtn.style.boxShadow = '0 4px 10px rgba(0,0,0,0.2)';
    toggleBtn.innerHTML = '<span id="chatIcon" style="color: white; font-size: 20px;">💬</span>';

    const iframe = document.createElement('iframe');
    iframe.id = 'chatIframe';
    iframe.src = iframeSrc;
    iframe.width = '400';
    iframe.height = '500';
    iframe.frameBorder = '0';
    iframe.allowFullscreen = true;
    iframe.style.display = 'none';
    iframe.style.marginTop = '10px';
    iframe.style.borderRadius = '12px';
    iframe.style.boxShadow = '0 0 15px rgba(0,0,0,0.1)';
    iframe.style.border = 'none';

    // کنترل باز و بسته شدن چت
    toggleBtn.addEventListener('click', () => {
        const isOpen = iframe.style.display === 'block';
        iframe.style.display = isOpen ? 'none' : 'block';

        // تغییر آیکن
        const icon = document.getElementById('chatIcon');
        icon.textContent = isOpen ? '💬' : '❌';
    });

    widgetContainer.appendChild(toggleBtn);
    widgetContainer.appendChild(iframe);
    document.body.appendChild(widgetContainer);
})();
