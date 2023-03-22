class Environment {
  Environment._();

  static const String server = "https://appmovil.utpl.edu.ec:8080";
  // static const String server = "http://172.18.137.102:3000";

  static const int httpTimeout = 12000;

  /// List of domains with Microsoft JWT authentication
  static const jwtMsAllowedDomains = [
    '172.18.137.102',
    'graph.microsoft.com',
    'appmovil.utpl.edu.ec'
  ];
  static const jwtAwsAllowedDomains = ['srv-si-001.utpl.edu.ec'];
  static const rolesAllowedDomains = ['172.18.137.102', 'appmovil.utpl.edu.ec'];

  // List of allowed roles for the user
  // static List<RolesModel> allowedRoles = [
  //   RolesModel(code: 'GS_ADMINISTRATIVOS', name: 'Administrativo', priority: 1),
  //   RolesModel(code: 'GS_ESTUDIANTES', name: 'Estudiante', priority: 3),
  //   RolesModel(code: 'GS_DOCENTES', name: 'Docente', priority: 2),
  // ];

  // static const adfsTenant = "6eeb49aa-436d-43e6-becd-bbdf79e5077d";
  // static const adfsClientId = "3beabeff-82f5-4214-b3a0-72f0d009fa7a";
  // static const adfsScope = "openid profile User.Read email";
  // static const adfsRedirectUri =
  //     "msauth://ec.edu.utpl.app/A0svlr6NLUBuoP0%2B1Y4QA23%2BDaA%3D";

  static const adfsTenant = "6eeb49aa-436d-43e6-becd-bbdf79e5077d";
  static const adfsScope = "openid profile User.Read email offline_access";
  // static const adfsClientId = "d44fde60-0c9e-4290-9f02-af78d39034b6";

  // static const adfsRedirectUri =
  //     "msauth://ec.edu.utpl.app/eSRE32usUdnm52f%2F%2BasUPa6MR%2BY%3D";

  // NOTE(jjvillavicencio): PRODUCTION
  static const adfsClientId = "d44fde60-0c9e-4290-9f02-af78d39034b6";
  static const adfsRedirectUri =
      "msauth://ec.edu.utpl.app/eSRE32usUdnm52f%2F%2BasUPa6MR%2BY%3D";

// NOTE(jjvillavicencio): DEVELOPMENT
  // static const adfsClientId = "3beabeff-82f5-4214-b3a0-72f0d009fa7a";
  // static const adfsRedirectUri =
  //     "msauth://ec.edu.utpl.app/A0svlr6NLUBuoP0%2B1Y4QA23%2BDaA%3D";
}
