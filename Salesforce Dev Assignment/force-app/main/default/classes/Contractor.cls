public  class Contractor extends Employee {

    public Decimal contractAmount;

    public Contractor(String name, String employeeId, String department, Decimal contractAmount) {
        Super(name, employeeId, department);
        this.contractAmount = contractAmount;
    }

    public override Decimal calculateSalary() {
        return contractAmount;
    }


    //Divide contract amount on monthly bases.
    public String generatePerformanceReport() {
        String performance;
        if ((this.contractAmount / 12) > 60000) { 
            performance = 'Excelent';
        } else {
            performance = 'Average';
        }
        return 'Performance Report based on per month Contract Amount is ' +  performance;
    }
}