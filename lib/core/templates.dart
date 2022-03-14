import 'package:docuzer/core/models/template_model.dart';

class Templates {
  static final TemplateModel _russianPassportModel = TemplateModel.fromJson(const <String, dynamic> {
    'title': 'Паспорт РФ',
    'emoji': '🛂',
  });

  static final TemplateModel _cardModel = TemplateModel.fromJson(const <String, dynamic> {
    'title': 'Банковская карта',
    'emoji': '💳',
  });

  static List<TemplateModel> initialTemplates() {
    return [
      _russianPassportModel,
      _cardModel,
    ];
  }
}