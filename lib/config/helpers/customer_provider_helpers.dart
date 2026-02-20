class CustomerProviderHelpers {
  static String completePhoneNumber(String phone) {
    String phoneComplete = phone.trim();
    //aqui asumo que el numero tiene 9 digitos
    // 927182755
    phoneComplete = ' +56$phoneComplete';
    return phoneComplete;
  }
}
