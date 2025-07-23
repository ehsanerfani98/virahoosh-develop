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
    widgetContainer.style.transition = 'all 0.3s ease';

    // دکمه باز کردن/بستن چت
    const toggleBtn = document.createElement('div');
    toggleBtn.id = 'chatToggleBtn';
    toggleBtn.style.width = '60px';
    toggleBtn.style.height = '60px';
    toggleBtn.style.borderRadius = '50%';
    toggleBtn.style.background = 'linear-gradient(135deg, #4285F4, #34A853)';
    toggleBtn.style.display = 'flex';
    toggleBtn.style.alignItems = 'center';
    toggleBtn.style.justifyContent = 'center';
    toggleBtn.style.cursor = 'pointer';
    toggleBtn.style.boxShadow = '0 4px 15px rgba(0,0,0,0.2)';
    toggleBtn.style.transition = 'all 0.3s ease, transform 0.2s ease';
    toggleBtn.style.position = 'relative';
    toggleBtn.style.overflow = 'hidden';

    // افکت هاله نور هنگام هاور
    const haloEffect = document.createElement('div');
    haloEffect.style.position = 'absolute';
    haloEffect.style.width = '100%';
    haloEffect.style.height = '100%';
    haloEffect.style.borderRadius = '50%';
    haloEffect.style.background = 'rgba(255, 255, 255, 0.2)';
    haloEffect.style.opacity = '0';
    haloEffect.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
    haloEffect.style.transform = 'scale(0.8)';

    // آیکن چت
    const chatIcon = document.createElement('div');
    chatIcon.id = 'chatIcon';
    chatIcon.style.color = 'white';
    chatIcon.style.fontSize = '24px';
    chatIcon.style.transition = 'all 0.3s ease';
    chatIcon.style.position = 'relative';
    chatIcon.style.zIndex = '1';
    chatIcon.innerHTML = '💬';

    toggleBtn.appendChild(haloEffect);
    toggleBtn.appendChild(chatIcon);

    // افکت‌های تعاملی برای دکمه
    toggleBtn.addEventListener('mouseenter', () => {
        haloEffect.style.opacity = '1';
        haloEffect.style.transform = 'scale(1.2)';
        toggleBtn.style.transform = 'translateY(-3px)';
        toggleBtn.style.boxShadow = '0 6px 20px rgba(0,0,0,0.25)';
    });

    toggleBtn.addEventListener('mouseleave', () => {
        haloEffect.style.opacity = '0';
        haloEffect.style.transform = 'scale(0.8)';
        toggleBtn.style.transform = 'translateY(0)';
        toggleBtn.style.boxShadow = '0 4px 15px rgba(0,0,0,0.2)';
    });

    // iframe چت
    const iframe = document.createElement('iframe');
    iframe.id = 'chatIframe';
    iframe.src = iframeSrc;
    iframe.width = '400';
    iframe.height = '500';
    iframe.frameBorder = '0';
    iframe.allowFullscreen = true;
    iframe.style.display = 'none';
    iframe.style.opacity = '0';
    iframe.style.transform = 'translateY(20px) scale(0.95)';
    iframe.style.transition = 'all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275)';
    iframe.style.borderRadius = '16px';
    iframe.style.boxShadow = '0 10px 30px rgba(0,0,0,0.15)';
    iframe.style.border = 'none';
    iframe.style.marginTop = '15px';
    iframe.style.transformOrigin = 'bottom right';

    // کنترل باز و بسته شدن چت با انیمیشن
    let isOpen = false;
    toggleBtn.addEventListener('click', () => {
        isOpen = !isOpen;
        
        if (isOpen) {
            iframe.style.display = 'block';
            setTimeout(() => {
                iframe.style.opacity = '1';
                iframe.style.transform = 'translateY(0) scale(1)';
            }, 10);
            
            // تغییر آیکن به ضربدر با انیمیشن
            chatIcon.style.transform = 'rotate(90deg)';
            setTimeout(() => {
                chatIcon.innerHTML = '✕';
                chatIcon.style.transform = 'rotate(0deg)';
                chatIcon.style.fontSize = '28px';
            }, 150);
            
            // بزرگ کردن دکمه هنگام باز بودن
            toggleBtn.style.transform = 'scale(1.05)';
        } else {
            iframe.style.opacity = '0';
            iframe.style.transform = 'translateY(20px) scale(0.95)';
            
            // تغییر آیکن به چت با انیمیشن
            chatIcon.style.transform = 'rotate(90deg)';
            setTimeout(() => {
                chatIcon.innerHTML = '💬';
                chatIcon.style.transform = 'rotate(0deg)';
                chatIcon.style.fontSize = '24px';
            }, 150);
            
            // بازگرداندن اندازه دکمه
            toggleBtn.style.transform = 'scale(1)';
            
            // مخفی کردن iframe پس از اتمام انیمیشن
            setTimeout(() => {
                iframe.style.display = 'none';
            }, 300);
        }
    });

    widgetContainer.appendChild(toggleBtn);
    widgetContainer.appendChild(iframe);
    document.body.appendChild(widgetContainer);
})();