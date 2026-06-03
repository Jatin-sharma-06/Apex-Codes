global class InactiveContactSchedular implements Schedulable {
    public void execute(SchedulableContext sc) {
        InactiveContactBatch batch = new InactiveContactBatch();
        Database.executeBatch(batch, 200);
    }
}