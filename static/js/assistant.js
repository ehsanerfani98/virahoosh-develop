(function () {
    // استخراج پارامتر از URL اسکریپت
    const scriptSrc = document.currentScript.src;
    const urlParams = new URL(scriptSrc).searchParams;
    const assistantId = urlParams.get('assistant_id');

    if (!assistantId) return;

    const iframeSrc = `http://127.0.0.1:8000/iframe/assistant/${assistantId}`;

    const googleapis = document.createElement('link');
    googleapis.href = "https://fonts.googleapis.com";
    googleapis.rel = "preconnect";
    document.head.appendChild(googleapis);

    const gstatic = document.createElement('link');
    gstatic.href = "https://fonts.gstatic.com";
    gstatic.rel = "preconnect";
    document.head.appendChild(gstatic);

    const vazirfont = document.createElement('link');
    vazirfont.href = "https://fonts.googleapis.com/css2?family=Vazirmatn:wght@100..900&display=swap";
    vazirfont.rel = "stylesheet";
    document.head.appendChild(vazirfont);


    // ساخت باکس چت شناور
    const widgetContainer = document.createElement('div');
    widgetContainer.id = 'chatWidgetContainer';
    widgetContainer.style.position = 'fixed';
    widgetContainer.style.bottom = '30px';
    widgetContainer.style.right = '50px';
    widgetContainer.style.zIndex = '9999';
    widgetContainer.style.transition = 'all 0.3s ease';

    // دکمه باز کردن/بستن چت
    const toggleBtn = document.createElement('div');
    toggleBtn.id = 'chatToggleBtn';
    toggleBtn.style.width = '40px';
    toggleBtn.style.height = '40px';
    toggleBtn.style.borderRadius = '50%';
    toggleBtn.style.background = 'linear-gradient(135deg, #4285F4, #34A853)';
    toggleBtn.style.display = 'flex';
    toggleBtn.style.alignItems = 'center';
    toggleBtn.style.justifyContent = 'center';
    toggleBtn.style.cursor = 'pointer';
    toggleBtn.style.boxShadow = '0 4px 15px rgba(0,0,0,0.2)';
    toggleBtn.style.transition = 'all 0.3s ease, transform 0.2s ease';
    toggleBtn.style.position = 'relative';
    toggleBtn.style.overflow = 'visible';

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
    chatIcon.style.fontSize = '20px';
    chatIcon.style.transition = 'all 0.3s ease';
    chatIcon.style.position = 'relative';
    chatIcon.style.zIndex = '1';
    chatIcon.innerHTML = '💬';

    // بالن توضیحات
    const tooltip = document.createElement('div');
    tooltip.id = 'chatTooltip';
    tooltip.innerHTML = 'دستیار هوش مصنوعی';
    tooltip.style.position = 'absolute';
    tooltip.style.bottom = 'calc(100% + 15px)';
    tooltip.style.right = '120%';
    tooltip.style.transform = 'translateX(50%)';
    tooltip.style.backgroundColor = '#fff';
    tooltip.style.color = '#333';
    tooltip.style.padding = '8px 12px';
    tooltip.style.borderRadius = '12px';
    tooltip.style.boxShadow = '0 2px 10px rgba(0,0,0,0.1)';
    tooltip.style.fontSize = '14px';
    tooltip.style.fontWeight = '500';
    tooltip.style.whiteSpace = 'nowrap';
    tooltip.style.opacity = '1';
    tooltip.style.transition = 'opacity 0.2s ease, transform 0.2s ease';
    tooltip.style.pointerEvents = 'none';
    tooltip.style.fontFamily = 'Vazirmatn';
    
    // پیکان بالن
    const tooltipArrow = document.createElement('div');
    tooltipArrow.style.position = 'absolute';
    tooltipArrow.style.top = '100%';
    tooltipArrow.style.left = '67%';
    tooltipArrow.style.transform = 'translateX(-50%)';
    tooltipArrow.style.width = '0';
    tooltipArrow.style.height = '0';
    tooltipArrow.style.borderLeft = '8px solid transparent';
    tooltipArrow.style.borderRight = '8px solid transparent';
    tooltipArrow.style.borderTop = '8px solid #fff';
    
    tooltip.appendChild(tooltipArrow);
    toggleBtn.appendChild(tooltip);

    toggleBtn.appendChild(haloEffect);
    toggleBtn.appendChild(chatIcon);

    // افکت‌های تعاملی برای دکمه
    toggleBtn.addEventListener('mouseenter', () => {
        haloEffect.style.opacity = '1';
        haloEffect.style.transform = 'scale(1.2)';
        toggleBtn.style.transform = 'translateY(-3px)';
        toggleBtn.style.boxShadow = '0 6px 20px rgba(0,0,0,0.25)';
        
        // نمایش بالن هنگام هاور (اگر چت بسته است)
        if (!isOpen) {
            tooltip.style.opacity = '1';
            tooltip.style.transform = 'translateX(50%) translateY(0)';
        }
    });

    toggleBtn.addEventListener('mouseleave', () => {
        haloEffect.style.opacity = '0';
        haloEffect.style.transform = 'scale(0.8)';
        toggleBtn.style.transform = 'translateY(0)';
        toggleBtn.style.boxShadow = '0 4px 15px rgba(0,0,0,0.2)';
        
        // مخفی کردن بالن هنگام خروج هاور (اگر چت بسته است)
        if (!isOpen) {
            tooltip.style.opacity = '0';
            tooltip.style.transform = 'translateX(50%) translateY(5px)';
        }
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
                chatIcon.style.fontSize = '20px';
            }, 150);
            
            // بزرگ کردن دکمه هنگام باز بودن
            toggleBtn.style.transform = 'scale(1.05)';
            
            // مخفی کردن بالن
            tooltip.style.opacity = '0';
            tooltip.style.transform = 'translateX(50%) translateY(5px)';
            tooltip.style.pointerEvents = 'none';
        } else {
            iframe.style.opacity = '0';
            iframe.style.transform = 'translateY(20px) scale(0.95)';
            
            // تغییر آیکن به چت با انیمیشن
            chatIcon.style.transform = 'rotate(90deg)';
            setTimeout(() => {
                chatIcon.innerHTML = '💬';
                chatIcon.style.transform = 'rotate(0deg)';
                chatIcon.style.fontSize = '20px';
            }, 150);
            
            // بازگرداندن اندازه دکمه
            toggleBtn.style.transform = 'scale(1)';
            
            // نمایش مجدد بالن
            setTimeout(() => {
                tooltip.style.opacity = '1';
                tooltip.style.transform = 'translateX(50%) translateY(0)';
            }, 300);
            
            // مخفی کردن iframe پس از اتمام انیمیشن
            setTimeout(() => {
                iframe.style.display = 'none';
            }, 300);
        }
    });

    // نمایش اولیه بالن با انیمیشن
    setTimeout(() => {
        tooltip.style.opacity = '1';
        tooltip.style.transform = 'translateX(50%) translateY(0)';
    }, 1000);

    widgetContainer.appendChild(toggleBtn);
    widgetContainer.appendChild(iframe);
    document.body.appendChild(widgetContainer);
})();