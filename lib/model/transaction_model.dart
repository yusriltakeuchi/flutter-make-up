class Transaction {
  int? id, jobId;
  String? total, address, status, date, start, end, createdAt;

  Transaction({
    this.id,
    this.jobId,
    this.total,
    this.address,
    this.status,
    this.date,
    this.start,
    this.end,
    this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json['id'],
        jobId: json['job_id'],
        total: json['total_people'],
        address: json['address'],
        status: json['status'],
        date: json['date'],
        start: json['start'],
        end: json['end'],
        createdAt: json['created_at'],
      );
}
