const $text_input = document.getElementById('text')
const $err_label = document.getElementById('err')
const $send_btn = document.getElementById('send')
const $connect_btn = document.getElementById('connect')
const $disconnect_btn = document.getElementById('disconnect')

$connect_btn.addEventListener('click', async () => {
	$err_label.innerText = 'Connecting...'
	$err_label.innerText = await chrome.runtime.sendMessage('connect')
})

$send_btn.addEventListener('click', async () =>
	$err_label.innerText = await chrome.runtime.sendMessage($text_input.value)
)

$disconnect_btn.addEventListener('click', async () =>
	$err_label.innerText = await chrome.runtime.sendMessage('disconnect') ?? ''
)
