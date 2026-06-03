public  class PartTimeEmployee extends Employee {
    public Decimal Salary;
    public Decimal hourlyRate;
    public Integer hoursWorked;

    public PartTimeEmployee(String name, String employeeId, String department, Decimal hourlyRate, Integer hoursWorked) {
        super(name, employeeId, department);
        this.hourlyRate = hourlyRate;
        this.hoursWorked = hoursWorked;
    }

    public override Decimal calculateSalary() {
        Salary = hourlyRate * hoursWorked;
        return Salary;
    }

    public String generatePerformanceReport() {
        String performance;
        if ((Salary / 12) > 60000) { 
            performance = 'Excelent';
        } else {
            performance = 'Average';
        }
        return 'Performance Report Based on Monthly Salary: ' + performance;
    }

}