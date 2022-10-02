import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/utils/widgets/top_bar.dart';

class ViewProfilePicture extends StatefulWidget {
  final UserModel userModel;
  final String imageurl;

  const ViewProfilePicture({
    Key? key,
    required this.userModel,
    required this.imageurl,
  }) : super(key: key);

  @override
  State<ViewProfilePicture> createState() => _ViewProfilePictureState();
}

class _ViewProfilePictureState extends State<ViewProfilePicture> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBar(left: widget.userModel.name),
            Expanded(
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: CachedNetworkImage(
                    imageUrl: widget.imageurl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Container(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
