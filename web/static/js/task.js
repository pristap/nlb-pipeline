let render = (task) => {
	return `
		<ul class="list-group">
			<li class="list-group-item">
				<b>Type:</b>
				${task.type}
			</li>
			<li class="list-group-item">
				<b>Product:</b>
				${task.product_id}
			</li>
			<li class="list-group-item">
				<b>Description:</b>
				${task.description}
			</li>
			<li class="list-group-item">
				<b>Name:</b>
				${task.name}
			</li>
			<li class="list-group-item">
				<b>Address:</b>
				${task.address}
			</li>
			<li class="list-group-item">
				<b>Phone №:</b>
				${task.phone}
			</li>
			<li class="list-group-item">
				<b>Email:</b>
				${task.email}
			</li>
			<li class="list-group-item">
				<b>Account №:</b>
				${task.account_no}
			</li>
			<li class="list-group-item">
				<b>Risk Management:</b>
				${task.guardian_id.replace(".", " ").replace(/\b\w/g, l => l.toUpperCase())}
			</li>
			<li class="list-group-item">
				<b>SMS Notification:</b>
				${task.sms_notification}
			</li>
			<li class="list-group-item">
				<b>Email Notification:</b>
				${task.email_notification}
			</li>
			<li class="list-group-item">
				<b>Processed:</b>
				${task.processed}
			</li>
			<li class="list-group-item">
				<b>Contacted:</b>
				${task.contacted}
			</li>
		</ul>
	`
}

export default {
	render
}