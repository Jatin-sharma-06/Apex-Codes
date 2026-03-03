public  Abstract class Employee implements Reportable {
    String name;
    String employeeId;
    String department;

    public Employee (String name, String employeeId, String department) {
        this.name =  name;
        this.employeeId = employeeId;
        this.department = department;
    }

    public Abstract Decimal calculateSalary();

    public String getDetails() {
        return 'Name: ' + name + ', Employee Id: ' + employeeId + ', Department: ' + department;
    }

}