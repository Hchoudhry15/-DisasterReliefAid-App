// import 'package:flutter/material.dart';

// class ChatBubble extends StatelessWidget {
//   const ChatBubble(
//       {Key? key,
//       required this.text,
//       required this.isCurrentUser,
//       required this.senderEmail})
//       : super(key: key);
//   final String text;
//   final bool isCurrentUser;
//   final String senderEmail;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       // asymmetric padding
//       padding: EdgeInsets.fromLTRB(
//         isCurrentUser ? 64.0 : 16.0,
//         4,
//         isCurrentUser ? 16.0 : 64.0,
//         4,
//       ),
//       child: Align(
//         // align the child within the container
//         alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
//         child: DecoratedBox(
//           // chat bubble decoration
//           decoration: BoxDecoration(
//             color: isCurrentUser ? Colors.blue : Colors.grey[300],
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(12),
//             child: Text(
//               senderEmail + ":\n" + text,
//               style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                   color: isCurrentUser ? Colors.white : Colors.black87),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.text,
    required this.isCurrentUser,
    required this.senderEmail,
  }) : super(key: key);

  final String text;
  final bool isCurrentUser;
  final String senderEmail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            senderEmail,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ),
        Padding(
          // asymmetric padding
          padding: EdgeInsets.fromLTRB(
            isCurrentUser ? 64.0 : 16.0,
            0,
            isCurrentUser ? 16.0 : 64.0,
            0,
          ),
          child: Align(
            // align the child within the container
            alignment:
                isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
            child: DecoratedBox(
              // chat bubble decoration
              decoration: BoxDecoration(
                color: isCurrentUser ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: isCurrentUser ? Colors.white : Colors.black87,
                      ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
