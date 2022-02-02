import 'package:algolia/algolia.dart';
import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/attachment.dart';
import 'package:doctor_mfc_admin/models/enums/attachment_type.dart';
import 'package:doctor_mfc_admin/models/enums/search_entity_type.dart';

class SearchEngine {
  /// Search engine instance.
  static final Algolia _algolia = Algolia.init(
    applicationId: kApplicationId,
    apiKey: kApiKey,
  );

  /// Minimum length of the search query.
  static const int _kMinQueryLength = 3;

  /// Returns a list of [SearchResult]s for the given `query` and [AttachmentType].
  Future<List<FileAttachment>> searchFile(
    String query,
    AttachmentType type,
  ) async {
    List<FileAttachment> results = [];

    // Only search if query is longer than the minimum characters required.
    if (query.length > _kMinQueryLength) {
      final algoliaQuery = _algolia.instance.index('dev_PROBLEMS').facetFilter([
        'entityTypeId:${SearchTypeConverter.attachmentTypeToSearchCode(type)!}'
      ]).query(query);
      final queryResults = await algoliaQuery.getObjects();

      queryResults.hits.forEach((object) {
        results.add(FileAttachment.fromMap(object.objectID, object.data));
      });
    }

    return results;
  }
}
