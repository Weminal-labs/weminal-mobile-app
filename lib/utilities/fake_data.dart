import '../models/event_model.dart';

class FakeData {
  FakeData._();
  static List<Map<String, dynamic>> json = [
    {
      "id": "evt-AipW3EfmGB81vDC",
      "name": "Introduction to Sui and Move",
      "cover_url": "assets/images/sui_bg.jpg",
      "created_at": "2024-03-12T01:41:30.679Z",
      "desription":
          "The Sui Foundation supports the advancement and adoption of the Sui blockchain ecosystem.",
      "start_at": "2024-03-21T12:00:00.000Z",
      "end_at": "2024-03-21T13:00:00.000Z",
      "location": {"name": "Ho Chi Minh city"},
      "timezone": "Europe/London",
      "ticket": {
        "total": 5,
        "price": 0,
        "is_sold_out": false,
        "spots_remaining": 0,
        "is_near_capacity": false,
        "ticket_currency": "usd"
      },
      "host": {
        "owner": "usr-eov0TQqLezYv8WO",
        "name": "Sui Foundation",
        "avatar_url":
            "https://images.lumacdn.com/avatars/79/26309b69-c772-47bd-8659-f4b2e9ca073e",
        "bio_short":
            "The Sui Foundation supports the advancement and adoption of the Sui blockchain ecosystem.",
        "website": "https://sui.io/",
        "instagram_handle": "",
        "linkedin_handle": "/company/sui-foundation",
        "tiktok_handle": "",
        "twitter_handle": "suinetwork",
        "youtube_handle": "Sui-Network",
        "timezone": "Asia/Manila"
      }
    },
    {
      "id": "evt-AipW3EfmGB81vDC",
      "name": "The VBI Blockchain Hackathon",
      "cover_url": "assets/images/vbi.jpg",
      "created_at": "2024-03-12T01:41:30.679Z",
      "desription":
          "The VBI Blockchain Hackathon is a programming competition event where computer programmers and others engage in blockchain-themed software development.",
      "start_at": "2024-03-21T12:00:00.000Z",
      "end_at": "2024-03-21T13:00:00.000Z",
      "location": {"name": "Ho Chi Minh city"},
      "timezone": "Europe/London",
      "ticket": {
        "total": 5,
        "price": 0,
        "is_sold_out": false,
        "spots_remaining": 0,
        "is_near_capacity": false,
        "ticket_currency": "usd"
      },
      "host": {
        "owner": "usr-eov0TQqLezYv8WO",
        "name": "Sui Foundation",
        "avatar_url":
            "https://images.lumacdn.com/avatars/79/26309b69-c772-47bd-8659-f4b2e9ca073e",
        "bio_short":
            "The Sui Foundation supports the advancement and adoption of the Sui blockchain ecosystem.",
        "website": "https://sui.io/",
        "instagram_handle": "",
        "linkedin_handle": "/company/sui-foundation",
        "tiktok_handle": "",
        "twitter_handle": "suinetwork",
        "youtube_handle": "Sui-Network",
        "timezone": "Asia/Manila"
      }
    },
    // 13 more events
  ];

  static int findIndexById(String id) {
    for (int i = 0; i < json.length; i++) {
      if (json[i]['id'] == id) {
        return i;
      }
    }
    return -1;
  }
}
