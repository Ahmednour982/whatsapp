import 'package:flutter/material.dart';

// ─── Message Model ───────────────────────────────────────────────
class ChatMessage {
  final String text;
  final bool isMe;
  final bool isImage;
  final String? imagePath;
  final String? time;

  ChatMessage({
    required this.text,
    required this.isMe,
    this.isImage = false,
    this.imagePath,
    this.time,
  });
}

// ─── whatsAppScreen ─────────────────────────────────────────────
class whatsAppScreen extends StatefulWidget {
  const whatsAppScreen({super.key});

  @override
  State<whatsAppScreen> createState() => _whatsAppScreenState();
}

class _whatsAppScreenState extends State<whatsAppScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _startConversation();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _startConversation() async {
    // Step 1: User sends "hello"
    await Future.delayed(const Duration(milliseconds: 800));
    _addMessage(ChatMessage(
      text: 'hello',
      isMe: true,
      time: _currentTime(),
    ));
    _scrollToBottom();

    // Step 2: Ahmed replies "hello"
    await Future.delayed(const Duration(milliseconds: 1200));
    _showTyping();
    await Future.delayed(const Duration(milliseconds: 1000));
    _hideTyping();
    _addMessage(ChatMessage(
      text: 'hello',
      isMe: false,
      time: _currentTime(),
    ));
    _scrollToBottom();

    // Step 3: Ahmed sends the long message
    await Future.delayed(const Duration(milliseconds: 1500));
    _showTyping();
    await Future.delayed(const Duration(milliseconds: 1500));
    _hideTyping();
    _addMessage(ChatMessage(
      text:
      'Hiya! Have you ever thought about how random moments can sometimes turn into the best memories? It\'s like the universe loves to surprise us when we least expect it!',
      isMe: false,
      time: _currentTime(),
    ));
    _scrollToBottom();

    // Step 4: User sends an image
    await Future.delayed(const Duration(milliseconds: 1500));
    _addMessage(ChatMessage(
      text: '',
      isMe: true,
      isImage: true,
      imagePath: 'assets/images/wallpaper.png',
      time: _currentTime(),
    ));
    _scrollToBottom();

    // Step 5: Ahmed replies with text
    await Future.delayed(const Duration(milliseconds: 1500));
    _showTyping();
    await Future.delayed(const Duration(milliseconds: 1500));
    _hideTyping();
    _addMessage(ChatMessage(
      text:
      'That\'s a beautiful photo! 📸 It really captures the moment perfectly. Moments like these are what make life so special!',
      isMe: false,
      time: _currentTime(),
    ));
    _scrollToBottom();
  }

  void _showTyping() {
    setState(() => _isTyping = true);
  }

  void _hideTyping() {
    setState(() => _isTyping = false);
  }

  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.add(message);
    });
  }

  String _currentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _addMessage(ChatMessage(
      text: text,
      isMe: true,
      time: _currentTime(),
    ));
    _messageController.clear();
    _scrollToBottom();

    // Auto reply
    _showTyping();
    Future.delayed(const Duration(milliseconds: 1500), () {
      _hideTyping();
      _addMessage(ChatMessage(
        text: 'Got it! 👍',
        isMe: false,
        time: _currentTime(),
      ));
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: _buildChatBody(),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  // ─── App Bar ─────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF1B8C4B),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      leadingWidth: 50,
      title: Row(
        children: [
          // Profile Picture
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
              image: const DecorationImage(
                image: AssetImage('assets/images/wallpaper.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Ahmed Nour',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'online',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.videocam, color: Colors.white, size: 24),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.call, color: Colors.white, size: 22),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  // ─── Chat Body ───────────────────────────────────────────────
  Widget _buildChatBody() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1B1B1B),
      ),
      child: Stack(
        children: [
          // WhatsApp-style background pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: Image.asset(
                'assets/images/wallpaper.png',
                fit: BoxFit.cover,
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),
          // Messages List
          ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: _messages.length + (_isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length && _isTyping) {
                return _buildTypingIndicator();
              }
              return _buildMessageBubble(_messages[index]);
            },
          ),
        ],
      ),
    );
  }

  // ─── Typing Indicator ────────────────────────────────────────
  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1B8C4B),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0),
            const SizedBox(width: 4),
            _buildDot(1),
            const SizedBox(width: 4),
            _buildDot(2),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  // ─── Message Bubble ──────────────────────────────────────────
  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: message.isImage
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: message.isMe ? Colors.white : const Color(0xFF1B8C4B),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isMe ? 16 : 4),
            bottomRight: Radius.circular(message.isMe ? 4 : 16),
          ),
        ),
        child: message.isImage
            ? ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Image.asset(
            message.imagePath ?? 'assets/images/wallpaper.png',
            fit: BoxFit.cover,
            width: 220,
            height: 280,
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isMe
                    ? const Color(0xFF1B1B1B)
                    : Colors.white,
                fontSize: 16,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.time ?? '',
                  style: TextStyle(
                    color: message.isMe
                        ? Colors.black45
                        : Colors.white54,
                    fontSize: 11,
                  ),
                ),
                if (message.isMe) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.done_all,
                    size: 16,
                    color: Color(0xFF1B8C4B),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Input Bar ───────────────────────────────────────────────
  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: const Color(0xFF1B1B1B),
      child: Row(
        children: [
          // Emoji Button
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emoji_emotions_outlined,
                color: Colors.white54, size: 24),
          ),
          const SizedBox(width: 8),
          // Text Field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  const Icon(Icons.attach_file,
                      color: Colors.white54, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      focusNode: _focusNode,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          color: Colors.white38,
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 12),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.camera_alt_outlined,
                      color: Colors.white54, size: 24),
                  const SizedBox(width: 14),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Send Button
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF1B8C4B),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}