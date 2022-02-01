

class StOnboardingFormData {
  List<FormData> personData = [];
  List<FormData> genderData = [];
  List<FormData> educationData = [];
  List<FormData> nationalityData = [];
  List<FormData> docTypeData = [];
  List<FormData> activityTypeData = [];
  List<FormData> ciiuData = [];
  List<StateFormData> stateData = [];

  List<Map> getGenderDataOptions(bool defaullOpt) {
    List<Map> res = [];
    if (defaullOpt == true) {
      res.add({"text": "Seleccione un género", "value": ""});
    }

    res.addAll(genderData.map((FormData of) {
      return of.getDataOption();
    }).toList());
    return res;
  }

  List<Map> getEducationDataOptions(bool defaullOpt) {
    List<Map> res = [];
    if (defaullOpt == true) {
      res.add({"text": "Seleccione un nivel de educacion", "value": ""});
    }

    res.addAll(educationData.map((FormData of) {
      return of.getDataOption();
    }).toList());
    return res;
  }

  List<Map> getActivityTypeDataOptions(bool defaullOpt) {
    List<Map> res = [];
    if (defaullOpt == true) {
      res.add({"text": "Selecciona fuente de ingresos", "value": ""});
    }

    res.addAll(activityTypeData.map((FormData of) {
      return of.getDataOption();
    }).toList());
    return res;
  }

  List<Map> getNationalityDataOptions(bool defaullOpt) {
    List<Map> res = [];
    if (defaullOpt == true) {
      res.add({"text": "Seleccione una nacionalidad", "value": ""});
    }

    res.addAll(educationData.map((FormData of) {
      return of.getDataOption();
    }).toList());
    return res;
  }

  List<Map> getStateDataOptions(bool defaullOpt) {
    List<Map> res = [];
    if (defaullOpt == true) {
      res.add({"text": "Seleccione un departamento", "value": ""});
    }

    res.addAll(stateData.map((StateFormData of) {
      return of.getDataOption();
    }).toList());
    return res;
  }

  List<Map> getCIIUDataOptions(bool defaullOpt) {
    List<Map> res = [];
    if (defaullOpt == true) {
      res.add({"text": "Selecciona actividad económica", "value": ""});
    }

    res.addAll(ciiuData.map((FormData of) {
      return of.getDataOption();
    }).toList());
    return res;
  }

  List<Map> getCityDataOptions(String stateCode, bool defaullOpt) {
    if (stateCode == null || stateCode == "") {
      return [];
    }

    StateFormData fd = findState(stateCode);
    if (fd != null) {
      return fd.getCityDataOptions(defaullOpt);
    }
    return null;
  }

  StateFormData findState(String stateCode) {
    return stateData.singleWhere((StateFormData sfd) {
      return sfd.paramCode == stateCode;
    }, orElse: () {
      return StateFormData(
          paramCode: stateCode, paramType: "?", paramValue: "Desconocido");
    });
  }
}

class FormData {
  String paramType;
  String paramCode;
  String paramValue;
  FormData({
    this.paramCode,
    this.paramType,
    this.paramValue,
  });

  Map getDataOption() {
    return {"text": paramValue, "value": paramCode};
  }
}

class StateFormData {
  List<FormData> cityData = [];
  String paramType;
  String paramCode;
  String paramValue;
  StateFormData({
    this.paramCode,
    this.paramType,
    this.paramValue,
    this.cityData,
  });

  Map getDataOption() {
    return {"text": paramValue, "value": paramCode};
  }

  List<Map> getCityDataOptions(bool defaullOpt) {
    List<Map> res = [];
    if (defaullOpt == true) {
      res.add({"text": "Seleccione una ciudad", "value": ""});
    }

    res.addAll(cityData.map((FormData of) {
      return of.getDataOption();
    }).toList());
    return res;
  }
}
