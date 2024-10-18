// rules_agreement.js
document.addEventListener("DOMContentLoaded", () => {
    const checkFirstLogin = async () => {
        const response = await fetch('/check_rules');
        const data = await response.json();

        if (data.first_login) {
            showModal(data.rules);
        }
    };

    const showModal = (rules) => {
        const modalHTML = `
            <div class="rules-modal">
                <div class="rules-modal-content">
                    <h2>Community Rules</h2>
                    <p>Please read and accept the following rules to gain Trust Level 1:</p>
                    <ul>${rules.split('\n').map(rule => `<li>${rule}</li>`).join('')}</ul>
                    <button id="agree-button">I Agree</button>
                </div>
            </div>
        `;

        document.body.insertAdjacentHTML('beforeend', modalHTML);

        document.getElementById('agree-button').addEventListener('click', () => {
            fetch('/check_rules', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ agreed: true })
            }).then(() => {
                document.querySelector('.rules-modal').remove();
            });
        });
    };

    checkFirstLogin();
});
