class TranslateRelatedTags {
  static String translate(String tag) {
    switch (tag) {
      case 'Section':
        return 'Paralelo';
      case 'AcademicLevel':
        return 'Nivel académico';
      case 'Department':
        return 'Departamento';
      case 'Faculty':
        return 'Facultad';
      case 'Modality':
        return 'Modalidad';
      case 'AcademicPeriod':
        return 'Periodo';
      case 'ImpartWay':
        return 'Impartición';
      case 'Program':
        return 'Programa';
      default:
        return tag;
    }
  }
}
