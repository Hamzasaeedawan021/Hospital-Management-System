-- Create database
CREATE DATABASE HospitalManagementsystem;
USE HospitalManagementsystem;

-- Patients table
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F', 'O')),
    BloodType VARCHAR(3),
    Phone VARCHAR(15),
    Email VARCHAR(100),
    Address VARCHAR(200),
    City VARCHAR(50),
    State VARCHAR(50),
    ZipCode VARCHAR(10),
    EmergencyContactName VARCHAR(100),
    EmergencyContactPhone VARCHAR(15),
    RegistrationDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Departments table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(100) NOT NULL,
    Description TEXT,
    Location VARCHAR(100)
);

-- Doctors table
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Specialization VARCHAR(100),
    DepartmentID INT,
    Phone VARCHAR(15),
    Email VARCHAR(100),
    HireDate DATE,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Nurses table
CREATE TABLE Nurses (
    NurseID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DepartmentID INT,
    Phone VARCHAR(15),
    Email VARCHAR(100),
    HireDate DATE,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Staff table (other hospital staff)
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Position VARCHAR(100),
    DepartmentID INT,
    Phone VARCHAR(15),
    Email VARCHAR(100),
    HireDate DATE,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Appointments table
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDate DATETIME NOT NULL,
    Purpose VARCHAR(200),
    Status VARCHAR(20) DEFAULT 'Scheduled' CHECK (Status IN ('Scheduled', 'Completed', 'Cancelled', 'No-Show')),
    Notes TEXT,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Rooms table
CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY AUTO_INCREMENT,
    RoomNumber VARCHAR(10) NOT NULL,
    RoomType VARCHAR(50) NOT NULL,
    DepartmentID INT,
    Status VARCHAR(20) DEFAULT 'Available' CHECK (Status IN ('Available', 'Occupied', 'Maintenance')),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Admissions table
CREATE TABLE Admissions (
    AdmissionID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT NOT NULL,
    AdmissionDate DATETIME NOT NULL,
    DischargeDate DATETIME,
    RoomID INT,
    DoctorID INT,
    Diagnosis TEXT,
    Status VARCHAR(20) DEFAULT 'Admitted' CHECK (Status IN ('Admitted', 'Discharged', 'Transferred')),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Treatments table
CREATE TABLE Treatments (
    TreatmentID INT PRIMARY KEY AUTO_INCREMENT,
    AdmissionID INT,
    TreatmentName VARCHAR(100) NOT NULL,
    Description TEXT,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME,
    DoctorID INT,
    Status VARCHAR(20) DEFAULT 'Ongoing' CHECK (Status IN ('Planned', 'Ongoing', 'Completed', 'Cancelled')),
    FOREIGN KEY (AdmissionID) REFERENCES Admissions(AdmissionID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Medications table
CREATE TABLE Medications (
    MedicationID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Description TEXT,
    Manufacturer VARCHAR(100),
    Cost DECIMAL(10, 2)
);

-- Prescriptions table
CREATE TABLE Prescriptions (
    PrescriptionID INT PRIMARY KEY AUTO_INCREMENT,
    TreatmentID INT,
    MedicationID INT,
    Dosage VARCHAR(50) NOT NULL,
    Frequency VARCHAR(50) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE,
    Instructions TEXT,
    FOREIGN KEY (TreatmentID) REFERENCES Treatments(TreatmentID),
    FOREIGN KEY (MedicationID) REFERENCES Medications(MedicationID)
);

-- Billing table
CREATE TABLE Billing (
    BillID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT NOT NULL,
    AdmissionID INT,
    BillDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(12, 2) NOT NULL,
    PaidAmount DECIMAL(12, 2) DEFAULT 0,
    PaymentMethod VARCHAR(50),
    Status VARCHAR(20) DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Partial', 'Paid', 'Cancelled')),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (AdmissionID) REFERENCES Admissions(AdmissionID)
);

-- BillingDetails table
CREATE TABLE BillingDetails (
    BillingDetailID INT PRIMARY KEY AUTO_INCREMENT,
    BillID INT NOT NULL,
    ItemType VARCHAR(50) NOT NULL,
    Description VARCHAR(200) NOT NULL,
    Quantity INT DEFAULT 1,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (BillID) REFERENCES Billing(BillID)
);

-- Now insertion
-- Insert Departments
INSERT INTO Departments (DepartmentName, Description, Location) VALUES
('Cardiology', 'Heart and cardiovascular system', 'First Floor, Wing A'),
('Pediatrics', 'Child healthcare', 'Ground Floor, Wing B'),
('Orthopedics', 'Musculoskeletal system', 'Second Floor, Wing A'),
('Neurology', 'Nervous system disorders', 'First Floor, Wing C'),
('Emergency', 'Emergency medical services', 'Ground Floor, Main Building');

-- Insert Doctors (with Muslim names)
INSERT INTO Doctors (FirstName, LastName, Specialization, DepartmentID, Phone, Email, HireDate) VALUES
('Mohammed', 'Khan', 'Cardiologist', 1, '03001234567', 'dr.mkhan@hospital.com', '2015-06-15'),
('Aisha', 'Ahmed', 'Pediatrician', 2, '03011234567', 'dr.aahmed@hospital.com', '2018-03-22'),
('Ibrahim', 'Malik', 'Orthopedic Surgeon', 3, '03021234567', 'dr.imalik@hospital.com', '2016-11-10'),
('Fatima', 'Raza', 'Neurologist', 4, '03031234567', 'dr.fraza@hospital.com', '2019-05-18'),
('Yusuf', 'Hussain', 'Emergency Physician', 5, '03041234567', 'dr.yhussain@hospital.com', '2017-09-30');

-- Insert Nurses (with Muslim names)
INSERT INTO Nurses (FirstName, LastName, DepartmentID, Phone, Email, HireDate) VALUES
('Zainab', 'Ali', 1, '03051234567', 'n.zali@hospital.com', '2020-02-14'),
('Omar', 'Farooq', 2, '03061234567', 'n.ofarooq@hospital.com', '2019-07-08'),
('Amina', 'Shaikh', 3, '03071234567', 'n.ashaikh@hospital.com', '2021-01-25'),
('Bilal', 'Iqbal', 4, '03081234567', 'n.biqbal@hospital.com', '2018-11-03'),
('Hafsa', 'Qureshi', 5, '03091234567', 'n.hqureshi@hospital.com', '2020-09-17');

-- Insert Patients (with Muslim names and Pakistani cities)
INSERT INTO Patients (FirstName, LastName, DateOfBirth, Gender, BloodType, Phone, Email, Address, City, State, ZipCode, EmergencyContactName, EmergencyContactPhone) VALUES
('Abdullah', 'Siddiqui', '1985-07-12', 'M', 'O+', '03101234567', 'abdullah.s@email.com', 'House 45, Street 10', 'Karachi', 'Sindh', '75500', 'Ali Siddiqui', '03111234567'),
('Maryam', 'Akhtar', '1992-03-25', 'F', 'A-', '03201234567', 'maryam.a@email.com', 'Flat 302, Gulberg Heights', 'Lahore', 'Punjab', '54000', 'Usman Akhtar', '03211234567'),
('Hamza', 'Rahman', '1978-11-08', 'M', 'B+', '03301234567', 'hamza.r@email.com', 'Village Kotli, Near Main Bazar', 'Faisalabad', 'Punjab', '38000', 'Asma Rahman', '03311234567'),
('Safia', 'Khalid', '1989-05-30', 'F', 'AB+', '03401234567', 'safia.k@email.com', 'Sector G-10/4', 'Islamabad', 'Federal', '44000', 'Khalid Mehmood', '03411234567'),
('Usman', 'Saleem', '1995-09-15', 'M', 'A+', '03501234567', 'usman.s@email.com', 'House 78, University Road', 'Peshawar', 'KPK', '25000', 'Farhan Saleem', '03511234567');

-- Insert Rooms
INSERT INTO Rooms (RoomNumber, RoomType, DepartmentID, Status) VALUES
('A101', 'General Ward', 1, 'Available'),
('A102', 'General Ward', 1, 'Occupied'),
('B201', 'Private Room', 2, 'Available'),
('B202', 'Private Room', 2, 'Available'),
('C301', 'ICU', 3, 'Occupied'),
('C302', 'ICU', 3, 'Maintenance'),
('D401', 'Operation Theater', 4, 'Available'),
('E501', 'Emergency Room', 5, 'Occupied');

-- Insert Medications
INSERT INTO Medications (Name, Description, Manufacturer, Cost) VALUES
('Paracetamol', 'Pain reliever and fever reducer', 'PharmaCo', 50.00),
('Amoxicillin', 'Antibiotic', 'MediCare', 120.00),
('Atorvastatin', 'Cholesterol medication', 'HealthPlus', 200.00),
('Metformin', 'Diabetes medication', 'BioLab', 85.00),
('Ibuprofen', 'Anti-inflammatory', 'PharmaCo', 60.00);

-- Insert Appointments
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, Purpose, Status) VALUES
(1, 1, '2023-06-15 10:00:00', 'Heart checkup', 'Completed'),
(2, 2, '2023-06-16 11:30:00', 'Child vaccination', 'Scheduled'),
(3, 3, '2023-06-17 14:00:00', 'Knee pain consultation', 'Scheduled'),
(4, 4, '2023-06-18 09:00:00', 'Headache evaluation', 'Cancelled'),
(5, 5, '2023-06-15 16:30:00', 'Follow-up after emergency', 'Completed');

-- Insert Admissions
INSERT INTO Admissions (PatientID, AdmissionDate, DischargeDate, RoomID, DoctorID, Diagnosis, Status) VALUES
(1, '2023-06-10 08:15:00', NULL, 2, 1, 'Acute coronary syndrome', 'Admitted'),
(3, '2023-06-12 14:30:00', '2023-06-14 11:00:00', 5, 3, 'Fractured femur', 'Discharged'),
(5, '2023-06-14 22:45:00', NULL, 8, 5, 'Severe dehydration', 'Admitted');

-- Insert Treatments
INSERT INTO Treatments (AdmissionID, TreatmentName, Description, StartDate, EndDate, DoctorID, Status) VALUES
(1, 'Angioplasty', 'Coronary artery procedure', '2023-06-11 10:00:00', '2023-06-11 12:30:00', 1, 'Completed'),
(1, 'Medication Therapy', 'Post-surgery medications', '2023-06-11 13:00:00', NULL, 1, 'Ongoing'),
(2, 'Bone Setting', 'Femur fracture reduction', '2023-06-12 16:00:00', '2023-06-12 17:30:00', 3, 'Completed'),
(3, 'IV Fluid Therapy', 'Rehydration treatment', '2023-06-14 23:00:00', '2023-06-15 06:00:00', 5, 'Completed');

-- Insert Prescriptions
INSERT INTO Prescriptions (TreatmentID, MedicationID, Dosage, Frequency, StartDate, EndDate, Instructions) VALUES
(2, 1, '500mg', 'Every 6 hours', '2023-06-11', '2023-06-18', 'Take with food'),
(2, 2, '250mg', 'Every 8 hours', '2023-06-11', '2023-06-18', 'Complete full course'),
(4, 5, '200mg', 'Every 8 hours', '2023-06-15', '2023-06-17', 'As needed for pain');

-- Insert Billing
INSERT INTO Billing (PatientID, AdmissionID, BillDate, TotalAmount, PaidAmount, PaymentMethod, Status) VALUES
(1, 1, '2023-06-12', 150000.00, 50000.00, 'Credit Card', 'Partial'),
(3, 2, '2023-06-14', 75000.00, 75000.00, 'Cash', 'Paid'),
(5, 3, '2023-06-15', 25000.00, 0.00, NULL, 'Pending');

-- Insert BillingDetails
INSERT INTO BillingDetails (BillID, ItemType, Description, Quantity, UnitPrice, Amount) VALUES
(1, 'Surgery', 'Angioplasty procedure', 1, 120000.00, 120000.00),
(1, 'Room Charges', 'Private room (2 days)', 2, 10000.00, 20000.00),
(1, 'Medications', 'Post-op medicines', 1, 10000.00, 10000.00),
(2, 'Surgery', 'Bone setting procedure', 1, 50000.00, 50000.00),
(2, 'Room Charges', 'ICU (2 days)', 2, 10000.00, 20000.00),
(2, 'Medications', 'Pain management', 1, 5000.00, 5000.00),
(3, 'Room Charges', 'Emergency room (1 night)', 1, 15000.00, 15000.00),
(3, 'Treatment', 'IV Fluid therapy', 1, 10000.00, 10000.00);