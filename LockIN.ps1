<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clash Royale VC App</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Chosen Palette: Royal Blue & Gold Accents (Clash Royale Inspired) -->
    <!-- Application Structure Plan: The application now features a user-centric dashboard with real-time room listings. It starts with a prominent Clash Royale themed header. Below that, a user profile section allows setting and persisting a username. The main interaction area is divided into two columns on larger screens: Room Management (create/join controls) and Available Rooms (a dynamic board). This allows users to easily manage their connection or browse/join existing games. Status messages and voice controls remain prominent. This structure supports both direct connection and community browsing, enhancing usability for its intended gaming audience. -->
    <!-- Visualization & Content Choices: The core is still real-time audio. Visualizations are limited to UI states and a dynamic list. Status messages provide real-time feedback. Room listings are presented as cards with player names and game status. Colors are heavily influenced by Clash Royale's aesthetic (reds, blues, golds) for an immersive feel. No complex data visualizations (charts, graphs) are used, as the focus is on interactive communication setup and displaying user/room status clearly. -->
    <!-- CONFIRMATION: NO SVG graphics used. NO Mermaid JS used. -->
    <style>
        body { font-family: 'Inter', sans-serif; }
        /* Custom Clash Royale Colors */
        .clash-red-dark { background-color: #A00000; } /* Dark Red */
        .clash-red-light { background-color: #CC0000; } /* Bright Red */
        .clash-blue-dark { background-color: #1A237E; } /* Dark Blue */
        .clash-blue-light { background-color: #3F51B5; } /* Medium Blue */
        .clash-gold-dark { background-color: #B8860B; } /* Dark Gold */
        .clash-gold-light { background-color: #FFD700; } /* Bright Gold */
        .clash-gray-dark { background-color: #212121; } /* Very Dark Gray */
        .clash-green { background-color: #4CAF50; } /* Green for In Game */
        .clash-yellow { background-color: #FFC107; } /* Yellow for Waiting */

        /* Button Styles */
        .btn-primary {
            @apply bg-blue-700 text-white py-3 px-6 rounded-xl shadow-md hover:bg-blue-800 transition-all duration-200 ease-in-out;
        }
        .btn-secondary {
            @apply bg-red-700 text-white py-3 px-6 rounded-xl shadow-md hover:bg-red-800 transition-all duration-200 ease-in-out;
        }
        .btn-danger {
            @apply bg-gray-700 text-white py-3 px-6 rounded-xl shadow-md hover:bg-gray-800 transition-all duration-200 ease-in-out;
        }
        .btn-toggle {
            @apply bg-yellow-500 text-gray-900 py-3 px-6 rounded-xl shadow-md hover:bg-yellow-600 transition-all duration-200 ease-in-out;
        }
        .btn-join-room {
            @apply bg-green-500 text-white py-2 px-4 rounded-lg shadow-sm hover:bg-green-600 transition-all duration-200 ease-in-out text-sm;
        }
    </style>
</head>
<body class="bg-gradient-to-br from-red-800 to-red-600 min-h-screen flex items-center justify-center p-4">

    <div class="bg-white bg-opacity-95 rounded-3xl shadow-xl p-8 md:p-12 w-full max-w-4xl text-center border-4 border-yellow-500">
        <h1 class="text-4xl font-bold text-red-900 mb-6">Clash Royale Voice Chat Arena</h1>
        <p class="text-lg text-gray-700 mb-8">Connect with your opponent or teammates to strategize and chat during your battles!</p>

        <!-- User Profile Section -->
        <div class="bg-gray-100 rounded-xl p-6 mb-8 border border-gray-200 shadow-inner">
            <h2 class="text-2xl font-bold text-blue-800 mb-4">Your Profile</h2>
            <div class="mb-4">
                <label for="username-input" class="block text-gray-800 text-sm font-semibold mb-2">Your Clash Royale Username:</label>
                <input type="text" id="username-input" placeholder="Enter your username" class="w-full p-3 border-2 border-blue-300 rounded-lg focus:ring-2 focus:ring-yellow-500 focus:border-yellow-500 bg-gray-50 text-gray-800">
            </div>
            <p id="local-user-id" class="text-gray-600 text-xs mt-2 mb-4">Your User ID: Loading...</p>
            <button id="save-username-btn" class="bg-blue-600 text-white py-2 px-5 rounded-lg shadow-md hover:bg-blue-700 transition">Save Username</button>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-8 mb-8">
            <!-- Room Management Section -->
            <div class="bg-gray-100 rounded-xl p-6 border border-gray-200 shadow-inner">
                <h2 class="text-2xl font-bold text-blue-800 mb-4">Room Management</h2>
                <div class="space-y-6">
                    <div>
                        <label for="room-id-input" class="block text-gray-800 text-sm font-semibold mb-2">Enter Room ID:</label>
                        <input type="text" id="room-id-input" placeholder="e.g., epic-battle-123" class="w-full p-3 border-2 border-blue-300 rounded-lg focus:ring-2 focus:ring-yellow-500 focus:border-yellow-500 bg-gray-50 text-gray-800">
                    </div>

                    <div class="flex flex-col sm:flex-row gap-4 justify-center">
                        <button id="create-room-btn" class="btn-primary">Create Room</button>
                        <button id="join-room-btn" class="btn-secondary">Join Room</button>
                    </div>
                    <button id="leave-room-btn" class="btn-danger w-full sm:w-auto hidden">Leave Room</button>
                </div>
                 <div class="mt-8">
                    <p id="status-message" class="text-gray-700 text-sm font-medium">Ready to connect!</p>
                    <p id="connected-user-id" class="text-gray-600 text-xs"></p>
                </div>
            </div>

            <!-- Available Rooms Board -->
            <div class="bg-gray-100 rounded-xl p-6 border border-gray-200 shadow-inner">
                <h2 class="text-2xl font-bold text-blue-800 mb-4">Available Rooms</h2>
                <div id="rooms-board" class="space-y-4 max-h-96 overflow-y-auto pr-2">
                    <p class="text-gray-500 text-sm" id="no-rooms-message">No active rooms. Create one!</p>
                </div>
            </div>
        </div>


        <div id="controls" class="space-y-4 mt-8">
            <button id="toggle-mute-btn" class="btn-toggle w-full sm:w-auto hidden">Mute Microphone</button>
        </div>

        <!-- Hidden audio elements for remote streams -->
        <div id="remote-audio-streams" class="hidden"></div>
    </div>

    <!-- Message Box for Alerts -->
    <div id="message-box" class="fixed bottom-4 right-4 bg-teal-600 text-white p-4 rounded-lg shadow-lg hidden z-50">
        <p id="message-text"></p>
    </div>

    <!-- Firebase SDKs -->
    <script type="module">
        import { initializeApp } from "https://www.gstatic.com/firebasejs/11.6.1/firebase-app.js";
        import { getAuth, signInAnonymously, signInWithCustomToken, onAuthStateChanged } from "https://www.gstatic.com/firebasejs/11.6.1/firebase-auth.js";
        import { getFirestore, doc, getDoc, setDoc, updateDoc, onSnapshot, deleteDoc, collection } from "https://www.gstatic.com/firebasejs/11.6.1/firebase-firestore.js";

        // Firebase configuration (provided by environment)
        const firebaseConfig = JSON.parse(typeof __firebase_config !== 'undefined' ? __firebase_config : '{}');
        const appId = typeof __app_id !== 'undefined' ? __app_id : 'default-clash-royale-vc-app';
        const initialAuthToken = typeof __initial_auth_token !== 'undefined' ? __initial_auth_token : null;

        // Initialize Firebase
        const app = initializeApp(firebaseConfig);
        const db = getFirestore(app);
        const auth = getAuth(app);

        let localStream;
        let peerConnection;
        let roomId;
        let localUserId;
        let localUsername = '';
        let remoteAudioElements = {}; // Store remote audio elements by peerId
        let isMuted = false;
        let roomDocRef;
        let roomUnsubscribe;
        let usersCollectionRef;
        let currentUserDocRef;
        let usersUnsubscribe;
        let allRoomsUnsubscribe; // New unsubscribe for all rooms listener

        // UI elements
        const usernameInput = document.getElementById('username-input');
        const saveUsernameBtn = document.getElementById('save-username-btn');
        const roomIdInput = document.getElementById('room-id-input');
        const createRoomBtn = document.getElementById('create-room-btn');
        const joinRoomBtn = document.getElementById('join-room-btn');
        const leaveRoomBtn = document.getElementById('leave-room-btn');
        const toggleMuteBtn = document.getElementById('toggle-mute-btn');
        const statusMessage = document.getElementById('status-message');
        const localUserIdDisplay = document.getElementById('local-user-id');
        const connectedUserIdDisplay = document.getElementById('connected-user-id');
        const remoteAudioStreamsDiv = document.getElementById('remote-audio-streams');
        const messageBox = document.getElementById('message-box');
        const messageText = document.getElementById('message-text');
        const roomsBoard = document.getElementById('rooms-board');
        const noRoomsMessage = document.getElementById('no-rooms-message');

        // --- Utility Functions ---
        function showMessage(message, type = 'success', duration = 3000) {
            messageText.textContent = message;
            messageBox.className = `fixed bottom-4 right-4 p-4 rounded-lg shadow-lg z-50 ${type === 'error' ? 'bg-red-600' : 'bg-green-600'} text-white block`;
            setTimeout(() => {
                messageBox.classList.add('hidden');
            }, duration);
        }

        function updateStatus(message, append = false) {
            if (append) {
                statusMessage.textContent += ` ${message}`;
            } else {
                statusMessage.textContent = message;
            }
        }

        function setButtonsState(state) {
            if (state === 'idle') {
                createRoomBtn.classList.remove('hidden');
                joinRoomBtn.classList.remove('hidden');
                leaveRoomBtn.classList.add('hidden');
                toggleMuteBtn.classList.add('hidden');
                roomIdInput.disabled = false;
                // roomIdInput.value = ''; // Don't clear room ID input automatically now
                connectedUserIdDisplay.textContent = '';
                usernameInput.disabled = false; // Enable username input when idle
                saveUsernameBtn.disabled = false; // Enable save username button
            } else if (state === 'connected') {
                createRoomBtn.classList.add('hidden');
                joinRoomBtn.classList.add('hidden');
                leaveRoomBtn.classList.remove('hidden');
                toggleMuteBtn.classList.remove('hidden');
                roomIdInput.disabled = true;
                usernameInput.disabled = true; // Disable username input when in a call
                saveUsernameBtn.disabled = true; // Disable save username button
            } else if (state === 'connecting') {
                createRoomBtn.classList.add('hidden');
                joinRoomBtn.classList.add('hidden');
                leaveRoomBtn.classList.add('hidden'); // Still hidden until connected
                toggleMuteBtn.classList.add('hidden');
                roomIdInput.disabled = true;
                usernameInput.disabled = true; // Disable username input when in a call
                saveUsernameBtn.disabled = true; // Disable save username button
            }
        }

        // --- Firebase & Authentication ---
        onAuthStateChanged(auth, async (user) => {
            if (user) {
                localUserId = user.uid;
                localUserIdDisplay.textContent = `Your User ID: ${localUserId}`;
                
                // Initialize user profile references
                usersCollectionRef = collection(db, 'artifacts', appId, 'users');
                currentUserDocRef = doc(usersCollectionRef, localUserId);

                // Load and listen to user profile
                await loadUserProfile();
                listenToUserProfile();
                
                // Start listening to all rooms
                listenToAllRooms();

                updateStatus('Signed in. Ready to create or join a room.');
                setButtonsState('idle');
            } else {
                try {
                    if (initialAuthToken) {
                        await signInWithCustomToken(auth, initialAuthToken);
                    } else {
                        await signInAnonymously(auth);
                    }
                } catch (error) {
                    console.error("Error signing in anonymously:", error);
                    updateStatus('Error signing in. Please refresh.', 'error');
                }
            }
        });

        async function loadUserProfile() {
            try {
                const docSnap = await getDoc(currentUserDocRef);
                if (docSnap.exists()) {
                    localUsername = docSnap.data().username || '';
                    usernameInput.value = localUsername;
                    updateStatus('Username loaded.');
                } else {
                    showMessage('Welcome! Please set your Clash Royale username.', 'info', 5000);
                }
            } catch (e) {
                console.error("Error loading user profile:", e);
                showMessage('Error loading username.', 'error');
            }
        }

        async function saveUsername() {
            const newUsername = usernameInput.value.trim();
            if (!newUsername) {
                showMessage('Username cannot be empty!', 'error');
                return;
            }
            try {
                await setDoc(currentUserDocRef, { username: newUsername }, { merge: true });
                localUsername = newUsername;
                showMessage('Username saved successfully!', 'success');
            } catch (e) {
                console.error("Error saving username:", e);
                showMessage('Failed to save username.', 'error');
            }
        }

        function listenToUserProfile() {
            if (usersUnsubscribe) usersUnsubscribe(); // Unsubscribe previous listener
            usersUnsubscribe = onSnapshot(currentUserDocRef, (doc) => {
                if (doc.exists()) {
                    const data = doc.data();
                    // Update internal state if username changes elsewhere (e.g., another device)
                    localUsername = data.username || '';
                    if (usernameInput.value !== localUsername && !usernameInput.disabled) {
                        usernameInput.value = localUsername;
                    }
                }
            }, (error) => {
                console.error("Error listening to user profile:", error);
            });
        }


        // --- WebRTC Core Functions ---

        async function getLocalMedia() {
            try {
                localStream = await navigator.mediaDevices.getUserMedia({ audio: true, video: false });
                updateStatus('Microphone access granted.');
                return localStream;
            } catch (e) {
                console.error('Error getting user media:', e);
                updateStatus('Error: Could not access microphone. Please allow permissions.', 'error');
                showMessage('Microphone access denied or error. Please check permissions.', 'error');
                return null;
            }
        }

        async function createPeerConnection() {
            const servers = {
                iceServers: [{ urls: 'stun:stun.l.google.com:19302' }]
            };
            peerConnection = new RTCPeerConnection(servers);

            if (localStream) {
                localStream.getTracks().forEach(track => {
                    peerConnection.addTrack(track, localStream);
                });
            } else {
                 console.warn("Local stream not available when creating peer connection.");
            }

            peerConnection.ontrack = (event) => {
                const [remoteStream] = event.streams;
                const peerId = event.track.id;

                if (!remoteAudioElements[peerId]) {
                    const remoteAudio = document.createElement('audio');
                    remoteAudio.id = `remote-audio-${peerId}`;
                    remoteAudio.autoplay = true;
                    remoteAudio.playsinline = true;
                    remoteAudio.srcObject = remoteStream;
                    remoteAudioStreamsDiv.appendChild(remoteAudio);
                    remoteAudioElements[peerId] = remoteAudio;
                    remoteAudioStreamsDiv.classList.remove('hidden');
                    updateStatus(`Connected to opponent.`);
                    // Attempt to get opponent's username from room data
                    if (roomId && roomDocRef) {
                        getDoc(roomDocRef).then(docSnap => {
                            if (docSnap.exists()) {
                                const data = docSnap.data();
                                if (data.hostId === localUserId && data.opponentUsername) {
                                    connectedUserIdDisplay.textContent = `Opponent: ${data.opponentUsername}`;
                                } else if (data.opponentId === localUserId && data.hostUsername) {
                                    connectedUserIdDisplay.textContent = `Opponent: ${data.hostUsername}`;
                                }
                            }
                        });
                    }
                }
            };

            peerConnection.onicecandidate = async (event) => {
                if (event.candidate) {
                    const candidateData = event.candidate.toJSON();
                    try {
                        const docSnap = await getDoc(roomDocRef);
                        if (docSnap.exists()) {
                            const data = docSnap.data();
                            const isHost = data.hostId === localUserId;
                            if (isHost) {
                                await updateDoc(roomDocRef, {
                                    hostCandidates: [...(data.hostCandidates || []), candidateData]
                                });
                            } else {
                                await updateDoc(roomDocRef, {
                                    opponentCandidates: [...(data.opponentCandidates || []), candidateData]
                                });
                            }
                        }
                    } catch (e) {
                        console.error("Error adding ICE candidate to Firestore:", e);
                    }
                }
            };

            peerConnection.oniceconnectionstatechange = () => {
                updateStatus(`ICE connection state: ${peerConnection.iceConnectionState}`);
                if (peerConnection.iceConnectionState === 'failed' || peerConnection.iceConnectionState === 'disconnected' || peerConnection.iceConnectionState === 'closed') {
                    showMessage('Voice chat connection lost or failed.', 'error');
                    leaveRoom();
                }
            };
        }

        async function createRoomOffer() {
            if (!localUsername) {
                showMessage('Please set your Clash Royale Username first!', 'error');
                return;
            }

            updateStatus('Creating room...');
            setButtonsState('connecting');

            const roomInput = roomIdInput.value.trim();
            if (!roomInput) {
                showMessage('Please enter a Room ID.', 'error');
                setButtonsState('idle');
                return;
            }
            roomId = roomInput;
            roomDocRef = doc(db, 'artifacts', appId, 'public', 'data', 'vc_rooms', roomId);

            try {
                const roomSnap = await getDoc(roomDocRef);
                if (roomSnap.exists() && roomSnap.data().hostId) {
                    showMessage(`Room "${roomId}" already exists. Please join it or choose a different ID.`, 'error');
                    setButtonsState('idle');
                    return;
                }

                await getLocalMedia();
                if (!localStream) {
                    setButtonsState('idle');
                    return;
                }

                await createPeerConnection();

                const offer = await peerConnection.createOffer();
                await peerConnection.setLocalDescription(offer);

                await setDoc(roomDocRef, {
                    hostId: localUserId,
                    hostUsername: localUsername, // Store username
                    hostOffer: { sdp: offer.sdp, type: offer.type },
                    hostCandidates: [],
                    opponentId: null,
                    opponentUsername: null, // Initialize opponent username
                    opponentAnswer: null,
                    opponentCandidates: [],
                    status: 'waiting', // New status field
                    lastActivity: new Date()
                });

                // Update current user's profile
                await updateDoc(currentUserDocRef, {
                    currentRoomId: roomId,
                    inGameStatus: 'waiting'
                });

                updateStatus(`Room "${roomId}" created. Waiting for opponent...`);
                setButtonsState('connected');
                listenForRoomChanges();
                showMessage(`Room "${roomId}" created! Share this ID with your opponent.`, 'success', 5000);

            } catch (e) {
                console.error('Error creating room:', e);
                updateStatus('Error creating room.', 'error');
                showMessage('Failed to create room. See console for details.', 'error');
                setButtonsState('idle');
            }
        }

        async function joinRoomAnswer(roomToJoinId = null) {
            if (!localUsername) {
                showMessage('Please set your Clash Royale Username first!', 'error');
                return;
            }

            updateStatus('Joining room...');
            setButtonsState('connecting');

            const roomInput = roomToJoinId || roomIdInput.value.trim();
            if (!roomInput) {
                showMessage('Please enter a Room ID to join or select from the list.', 'error');
                setButtonsState('idle');
                return;
            }
            roomId = roomInput;
            roomDocRef = doc(db, 'artifacts', appId, 'public', 'data', 'vc_rooms', roomId);

            try {
                const roomSnap = await getDoc(roomDocRef);
                if (!roomSnap.exists() || !roomSnap.data().hostOffer) {
                    showMessage(`Room "${roomId}" does not exist or is not ready.`, 'error');
                    setButtonsState('idle');
                    return;
                }
                const roomData = roomSnap.data();
                if (roomData.opponentId) {
                     showMessage(`Room "${roomId}" already has an opponent.`, 'error');
                     setButtonsState('idle');
                     return;
                }
                if (roomData.hostId === localUserId) {
                    showMessage('You are already the host of this room.', 'error');
                    setButtonsState('connected'); // If already host, just return to connected state
                    return;
                }

                await getLocalMedia();
                if (!localStream) {
                    setButtonsState('idle');
                    return;
                }

                await createPeerConnection();

                const offer = new RTCSessionDescription(roomData.hostOffer);
                await peerConnection.setRemoteDescription(offer);

                const answer = await peerConnection.createAnswer();
                await peerConnection.setLocalDescription(answer);

                await updateDoc(roomDocRef, {
                    opponentId: localUserId,
                    opponentUsername: localUsername, // Store username
                    opponentAnswer: { sdp: answer.sdp, type: answer.type },
                    opponentCandidates: [],
                    status: 'in-game', // Update status
                    lastActivity: new Date()
                });

                // Update current user's profile
                await updateDoc(currentUserDocRef, {
                    currentRoomId: roomId,
                    inGameStatus: 'in-game'
                });

                updateStatus(`Joined room "${roomId}". Connecting...`);
                setButtonsState('connected');
                listenForRoomChanges();

                // Add any existing host candidates
                if (roomData.hostCandidates && roomData.hostCandidates.length > 0) {
                    for (const candidateData of roomData.hostCandidates) {
                        await peerConnection.addIceCandidate(new RTCIceCandidate(candidateData));
                    }
                }
                showMessage(`Joined room "${roomId}" successfully!`, 'success', 5000);
                roomIdInput.value = roomId; // Ensure input field shows joined room ID

            } catch (e) {
                console.error('Error joining room:', e);
                updateStatus('Error joining room. Make sure the ID is correct and room is active.', 'error');
                showMessage('Failed to join room. See console for details.', 'error');
                setButtonsState('idle');
            }
        }

        function listenForRoomChanges() {
            if (roomUnsubscribe) roomUnsubscribe();
            roomUnsubscribe = onSnapshot(roomDocRef, async (docSnap) => {
                if (docSnap.exists()) {
                    const data = docSnap.data();

                    // Host: process opponent's answer
                    if (data.opponentId && data.opponentAnswer && data.hostId === localUserId && peerConnection.remoteDescription === null) {
                        updateStatus('Opponent connected. Receiving answer...');
                        const answer = new RTCSessionDescription(data.opponentAnswer);
                        await peerConnection.setRemoteDescription(answer);
                        connectedUserIdDisplay.textContent = `Opponent: ${data.opponentUsername}`;

                        // Add any existing opponent candidates
                        if (data.opponentCandidates && data.opponentCandidates.length > 0) {
                            for (const candidateData of data.opponentCandidates) {
                                await peerConnection.addIceCandidate(new RTCIceCandidate(candidateData));
                            }
                        }
                    }

                    // Handle incoming candidates (for both host and opponent)
                    if (data.hostId === localUserId && data.opponentCandidates && peerConnection.signalingState === 'stable') {
                        const currentCandidateCount = peerConnection.remoteDescription && peerConnection.remoteDescription.candidatesProcessed !== undefined ? peerConnection.remoteDescription.candidatesProcessed : 0;
                        for (let i = currentCandidateCount; i < data.opponentCandidates.length; i++) {
                            await peerConnection.addIceCandidate(new RTCIceCandidate(data.opponentCandidates[i]));
                            updateStatus('Adding opponent ICE candidate.');
                        }
                        if (peerConnection.remoteDescription) {
                            peerConnection.remoteDescription.candidatesProcessed = data.opponentCandidates.length;
                        }

                    } else if (data.opponentId === localUserId && data.hostCandidates && peerConnection.signalingState === 'have-remote-offer') {
                        const currentCandidateCount = peerConnection.remoteDescription && peerConnection.remoteDescription.candidatesProcessed !== undefined ? peerConnection.remoteDescription.candidatesProcessed : 0;
                         for (let i = currentCandidateCount; i < data.hostCandidates.length; i++) {
                            await peerConnection.addIceCandidate(new RTCIceCandidate(data.hostCandidates[i]));
                            updateStatus('Adding host ICE candidate.');
                        }
                        if (peerConnection.remoteDescription) {
                            peerConnection.remoteDescription.candidatesProcessed = data.hostCandidates.length;
                        }
                    }
                } else {
                    updateStatus('Room closed by opponent or host. Disconnected.', 'error');
                    showMessage('The room has been closed.', 'error');
                    leaveRoom();
                }
            }, (error) => {
                console.error("Error listening to room changes:", error);
                updateStatus('Error listening to room updates.', 'error');
            });
        }

        function toggleMute() {
            if (localStream) {
                localStream.getAudioTracks().forEach(track => {
                    track.enabled = !track.enabled;
                    isMuted = !track.enabled;
                    toggleMuteBtn.textContent = isMuted ? 'Unmute Microphone' : 'Mute Microphone';
                    updateStatus(isMuted ? 'Microphone muted.' : 'Microphone unmuted.');
                });
            }
        }

        async function leaveRoom() {
            updateStatus('Leaving room...');

            if (localStream) {
                localStream.getTracks().forEach(track => track.stop());
                localStream = null;
            }

            if (peerConnection) {
                peerConnection.close();
                peerConnection = null;
            }

            remoteAudioStreamsDiv.innerHTML = '';
            remoteAudioElements = {};
            remoteAudioStreamsDiv.classList.add('hidden');

            if (roomUnsubscribe) {
                roomUnsubscribe();
                roomUnsubscribe = null;
            }

            if (allRoomsUnsubscribe) {
                allRoomsUnsubscribe();
                allRoomsUnsubscribe = null;
            }

            if (roomId && localUserId) {
                try {
                    const docSnap = await getDoc(doc(db, 'artifacts', appId, 'public', 'data', 'vc_rooms', roomId));
                    if (docSnap.exists()) {
                        const data = docSnap.data();
                        if (data.hostId === localUserId) {
                            await deleteDoc(doc(db, 'artifacts', appId, 'public', 'data', 'vc_rooms', roomId));
                            showMessage('Room deleted successfully.', 'success');
                        } else if (data.opponentId === localUserId) {
                            await updateDoc(doc(db, 'artifacts', appId, 'public', 'data', 'vc_rooms', roomId), {
                                opponentId: null,
                                opponentUsername: null,
                                opponentAnswer: null,
                                opponentCandidates: [],
                                status: 'waiting' // Change status back to waiting if opponent leaves
                            });
                             showMessage('Left room.', 'success');
                        } else {
                            showMessage('Left room (no active role).', 'success');
                        }
                    }
                } catch (e) {
                    console.error('Error cleaning up Firestore:', e);
                    showMessage('Error during room cleanup in Firestore.', 'error');
                }
            }

            // Clear user's current room status in their private profile
            if (currentUserDocRef) {
                try {
                    await updateDoc(currentUserDocRef, {
                        currentRoomId: null,
                        inGameStatus: null
                    });
                } catch (e) {
                    console.error("Error clearing user's room status:", e);
                }
            }


            roomId = null;
            roomDocRef = null;
            setButtonsState('idle');
            updateStatus('Disconnected.');
            isMuted = false;
            toggleMuteBtn.textContent = 'Mute Microphone';
            // Re-listen to all rooms after leaving
            listenToAllRooms();
        }

        // --- Room Board Functions ---
        function listenToAllRooms() {
            if (allRoomsUnsubscribe) allRoomsUnsubscribe(); // Unsubscribe previous listener
            const roomsCollection = collection(db, 'artifacts', appId, 'public', 'data', 'vc_rooms');
            
            allRoomsUnsubscribe = onSnapshot(roomsCollection, (snapshot) => {
                roomsBoard.innerHTML = ''; // Clear current list
                let hasRooms = false;

                snapshot.docs.forEach(docSnap => {
                    const roomData = docSnap.data();
                    const currentRoomId = docSnap.id;

                    // Only display rooms that have a host and are not completely empty
                    if (roomData.hostId) {
                        hasRooms = true;
                        const roomCard = document.createElement('div');
                        roomCard.className = 'bg-white p-4 rounded-lg shadow border border-blue-200';

                        let statusColor = '';
                        let statusText = '';
                        let joinButton = '';
                        let isLocalUserInRoom = (roomData.hostId === localUserId || roomData.opponentId === localUserId);

                        if (roomData.status === 'in-game') {
                            statusColor = 'bg-clash-red-light';
                            statusText = 'In Game';
                        } else if (roomData.status === 'waiting') {
                            statusColor = 'bg-clash-gold-light';
                            statusText = 'Waiting for Opponent';
                            // Only show join button if not already in this room and it's not full
                            if (!isLocalUserInRoom && !roomData.opponentId) {
                                joinButton = `<button data-room-id="${currentRoomId}" class="btn-join-room">Join</button>`;
                            }
                        }

                        roomCard.innerHTML = `
                            <div class="flex justify-between items-center mb-2">
                                <h3 class="font-bold text-lg text-blue-800">Room: ${currentRoomId}</h3>
                                <span class="px-3 py-1 text-xs font-semibold rounded-full text-white ${statusColor}">${statusText}</span>
                            </div>
                            <p class="text-sm text-gray-700">Host: ${roomData.hostUsername || 'N/A'}</p>
                            <p class="text-sm text-gray-700">Opponent: ${roomData.opponentUsername || 'N/A'}</p>
                            <div class="mt-3 flex justify-end">
                                ${joinButton}
                            </div>
                        `;
                        roomsBoard.appendChild(roomCard);
                    }
                });

                if (hasRooms) {
                    noRoomsMessage.classList.add('hidden');
                } else {
                    noRoomsMessage.classList.remove('hidden');
                }
                
                // Attach event listeners for dynamically added join buttons
                document.querySelectorAll('.btn-join-room').forEach(button => {
                    button.onclick = () => {
                        joinRoomAnswer(button.dataset.roomId);
                    };
                });
            }, (error) => {
                console.error("Error listening to all rooms:", error);
                updateStatus('Error loading rooms.', 'error');
            });
        }


        // --- Event Listeners ---
        saveUsernameBtn.addEventListener('click', saveUsername);
        createRoomBtn.addEventListener('click', createRoomOffer);
        joinRoomBtn.addEventListener('click', () => joinRoomAnswer()); // Default join behavior
        leaveRoomBtn.addEventListener('click', leaveRoom);
        toggleMuteBtn.addEventListener('click', toggleMute);

        // Initial setup - ensures correct state after page load
        setButtonsState('idle');
    </script>
</body>
</html>
