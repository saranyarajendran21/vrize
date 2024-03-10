class savedcardsmodel {
  String? cardHoldername;
  String? cardNumber;
  String? expirydate;
  String? cvvNumber;

  savedcardsmodel(
      {this.cardHoldername, this.cardNumber, this.expirydate, this.cvvNumber});

  savedcardsmodel.fromJson(Map<String, dynamic> json) {
    cardHoldername = json['cardHoldername'];
    cardNumber = json['cardNumber'];
    expirydate = json['expirydate'];
    cvvNumber = json['cvvNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardHoldername'] = this.cardHoldername;
    data['cardNumber'] = this.cardNumber;
    data['expirydate'] = this.expirydate;
    data['cvvNumber'] = this.cvvNumber;
    return data;
  }
}
