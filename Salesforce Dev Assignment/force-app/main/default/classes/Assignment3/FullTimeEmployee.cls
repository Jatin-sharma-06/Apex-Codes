public  class FullTimeEmployee extends Employee  {
    public Decimal Salary;

    public FullTimeEmployee(String name, String employeeID, String department, Decimal Salary) {
        Super(name, employeeID, department);
        this.Salary = Salary;
    }

    public override Decimal calculateSalary() {
        return Salary/12;
    }

    public String generatePerformanceReport() {
        String performance;
        if ((this.Salary / 12) > 60000) { 
            performance = 'Excelent';
        } else {
            performance = 'Average';
        }
        return 'Performance Report based on Monthly Salary: ' + performance;
    }

}
