/// Represents a lottery.
class Lottery {
  String? id;
  String? name;
  String? number;
  String? series;

  Lottery({
    this.id,
    this.name,
    this.number,
    this.series,
  });

  void setId(String id) {
    this.id = id;
  }

  void setName(String name) {
    this.name = name;
  }

  void setNumber(String number) {
    this.number = number;
  }

  void setSeries(String series) {
    this.series = series;
  }
}