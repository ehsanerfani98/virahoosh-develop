async function handleAjaxForm({
    url,
    method = "POST",
    payload,
    successMessage = "عملیات با موفقیت انجام شد",
    redirectUrl = null,
    storeTokens = false,
    alertContainerId = "alert-container"
}) {
    const alertContainer = document.getElementById(alertContainerId);
    alertContainer.innerHTML = "";

    try {
        const response = await fetch(url, {
            method,
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(payload),
        });

        const data = await response.json();

        if (response.ok) {
            if (storeTokens && data.access_token) {
                localStorage.setItem("access_token", data.access_token);
                localStorage.setItem("refresh_token", data.refresh_token);
            }

            alertContainer.innerHTML =
                <div class="alert alert-success text-center">${successMessage}</div>
                ;

            if (redirectUrl) {
                setTimeout(() => {
                    window.location.href = redirectUrl;
                }, 800);
            }

            return { success: true, data };
        } else {
            alertContainer.innerHTML =
                <div class="alert alert-danger text-center">${data.detail || data.error || "خطایی رخ داده است"}</div>
                ;
            return { success: false, data };
        }
    } catch (err) {
        alertContainer.innerHTML =
            <div class="alert alert-danger text-center">خطا در ارتباط با سرور</div>
            ;
        return { success: false, error: err };
    }
}


