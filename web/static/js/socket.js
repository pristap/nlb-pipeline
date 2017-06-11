// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import {Socket, Presence} from "phoenix"
import Task from "./task.js"

let taskDetails = document.getElementById("task_details")
let connectionLabel = document.getElementById("connection_label")
let statusLabel = document.getElementById("status")
let supportQueue = document.getElementById("support_queue")
let managementQueue = document.getElementById("management_queue")
let presencesList = document.getElementById("presences_list")
let actionButton = document.getElementById("action_button")

var user_type = null
var user_id = null
var users = {}

if (window.location.pathname.match(/^\/support\/(.+)/)) {
	user_id = window.location.pathname.match(/^\/support\/(.+)/)[1]
	user_type = "support"
}
else if (window.location.pathname.match(/^\/risk_management\/(.+)/)) {
	user_id = window.location.pathname.match(/^\/risk_management\/(.+)/)[1]
	user_type = "risk_management"
}
else if (window.location.pathname.match(/^\/dashboard/)) {
	user_id = "admin"
	user_type = "admin"
}


let params = {
	params: {
		user_id: user_id,
		user_type: user_type,
	},
	logger: (kind, msg, data) => {
		let datetime = new Date().toLocaleString('en-US')
		console.log(`${datetime}\n${kind}: ${msg}`, data)
	}
}

let socket = new Socket("/socket", params)

var channel = null
var controlChannel = null
var presences = {}
var currentTask = null
var management_tasks = []
var support_tasks = []

if (user_type && user_id) {

	socket.connect()

	controlChannel = socket.channel("control:lobby", {})

	// Now that you are connected, you can join channels with a topic:
	let roomName = (user_type != "risk_management") ? "lobby" : user_id
	channel = socket.channel(`${user_type}:${roomName}`, {"user_id": user_id})

	controlChannel.join()
	.receive("ok", resp => {
		console.log("Joined successfully", resp)

		controlChannel.on("users", listUsers)
		controlChannel.on("presence_state", presenceState)
		controlChannel.on("presence_diff", presenceDiff)

		channel.join()
		.receive("ok", resp => {
			console.log("Joined successfully", resp)

		channel.on("support:task:start", supportTaskStart)
		channel.on("support:task:finish", supportTaskFinish)
		channel.on("support:task:list", supportTaskList)
		// channel.on("support:task:new", supportTaskNew)

		channel.on("risk_management:task:start", managementTaskStart)
		channel.on("risk_management:task:finish", managementTaskFinish)
		channel.on("risk_management:task:list", managementTaskList)
		})
		.receive("error", resp => {
			console.log("Unable to join", resp)
		})
	})
	.receive("error", resp => {
			console.log("Unable to join", resp)
	})
}

let listPresences = (id, {metas: metas, status: status, task_id: task_id}) => {
	let [type, name] = id.split(":", 2)
	return {
		id: id,
		type: type,
		name: userName(name),
		count: metas.length,
		status: status,
		task_id: task_id
	}
}

let renderPresences = (presences) => {
	console.log("rendering", presences)
	Object.assign(users, presences)
	presencesList.innerHTML = Presence.list(users, listPresences)
		.map( (user) => {
			if (user.task_id) {
				return `<li class="list-group-item"><span class="${user.status}"></span> <span class="user_type">${userTypeIcon(user.type)}</span> ${user.name} <i>(${user.count})</i><br/><a href="../events/${user.task_id}">View Task</a></li>`
			}
			else {
				return `<li class="list-group-item"><span class="${user.status}"></span> <span class="user_type">${userTypeIcon(user.type)}</span> ${user.name} <i>(${user.count})</i>`
			}
		}).join("")
}

let renderTasks = (domElement, tasks) => {
	domElement.innerHTML = tasks
		.map(task => `<li class="list-group-item"><b>${task.type.toUpperCase()} ${task.product_id.toUpperCase()}:</b> <i>${task.account_no}</i> </li>`)
		.join("")
}

let listUsers = (data) => {
	users = {}
	for(let user of data.users) {
		let [type, name] = user.split(":", 2)
		users[user] = {
			id: user,
			type: type,
			name: name,
			status: "offline",
			count: 0,
			task_id: null,
			metas: []
		}
	}
}

let presenceState = (state) => {
	presences = Presence.syncState(presences, state)
	renderPresences(state)
}

let presenceDiff = (diff) => {
	presences = Presence.syncDiff(presences, diff)
	renderPresences(presences)
}

//	Management Callbacks

let managementTaskList = (data) => {
	management_tasks = data.tasks
	currentTask = management_tasks[0]
	taskDetails.innerHTML = Task.render(currentTask)
	renderTasks(managementQueue, management_tasks)
}

let managementTaskStart = (task) => {
	actionButton.innerText = "Finish"
}

let managementTaskFinish = (task) => {
	// management_tasks.shift()
	// currentTask = management_tasks[0]
	// taskDetails.innerHTML = Task.render(currentTask)
	// renderTasks(managementQueue, management_tasks)
	actionButton.innerText = "Start"
}

//	Support Callbacks

let supportTaskList = (data) => {
	support_tasks = data.tasks
	currentTask = support_tasks[0]
	taskDetails.innerHTML = Task.render(currentTask)
	renderTasks(supportQueue, support_tasks)
}

let supportTaskStart = (data) => {
	if (data.user_id == user_id) {
		actionButton.innerText = "Finish"
	}
	else {
		support_tasks = support_tasks.filter((task) => {
			return task.id != data.task_id
		})
		currentTask = support_tasks[0]
		taskDetails.innerHTML = Task.render(currentTask)
		renderTasks(supportQueue, support_tasks)
	}
}

let supportTaskFinish = (data) => {
	if (data.user_id == user_id) {
		// support_tasks.shift()
		// currentTask = support_tasks[0]
		// taskDetails.innerHTML = Task.render(currentTask)
		// renderTasks(supportQueue, support_tasks)
		actionButton.innerText = "Start"
	}
}

//	Event Listeners

if (actionButton) {
	actionButton.addEventListener("click", (e) => {
		switch (actionButton.innerText) {
			case "Start":
				channel.push(`${user_type}:task:start`, {"task": currentTask.id})
				break
			case "Finish":
				channel.push(`${user_type}:task:finish`, {"task": currentTask.id})
				break
			default:
				break;
		}
	})
}

//	Helper Methods

let userTypeIcon = (user_type) => {
	switch (user_type) {
		case "risk_management":
			return "℀"
		case "support":
			return "✆"
		default:
			console.log("Undefined User Type: ", user_type)
			return ""
	}
}

let userName = (user_id) => {
	return user_id.replace(".", " ").replace(/\b\w/g, l => l.toUpperCase())
}

export default socket
