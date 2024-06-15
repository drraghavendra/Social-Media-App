//Smart Contract for Applicants to submit their details and social media handle along with the idea description.
//Admin to review applications and set their status (Accepted, Rejected).
//Reviewers (potentially different from the admin) to provide feedback on applications.


// File: SocialIncubation.move

// Define the applicant structure with basic information
struct Applicant {
  pub name: vector<u8>,
  pub social_media_handle: vector<u8>,
  pub idea_description: vector<u8>,
}

// Define the application struct with review and status fields
struct Application {
  pub applicant: Applicant,
  pub reviewer: vector<u8>, // Stores the reviewer's wallet address
  pub review: vector<u8>,   // Stores the review text
  pub status: u8,           // 0: Pending, 1: Accepted, 2: Rejected
}

// Manage the Incubation Center state
struct SocialIncubation {
  pub admin: vector<u8>,       // Stores the admin wallet address
  pub applications: vector<Application>,
}

public entrypoint init(admin: vector<u8>) {
  // Create a new Incubation Center instance
  let incubation_center = SocialIncubation {
    admin: admin,
    applications: vec!(),
  };
  storage::save(incubation_center, SocialIncubation::KEY);
}

public fun apply(applicant: Applicant) {
  // Fetch the Incubation Center instance from storage
  let mut incubation_center = storage::load(SocialIncubation::KEY) as SocialIncubation;

  // Add the new application to the applications vector
  incubation_center.applications.push(Application {
    applicant: applicant,
    reviewer: vec!(),
    review: vec!(),
    status: 0,
  });

  // Save the updated state to storage
  storage::save(incubation_center, SocialIncubation::KEY);
}

public fun review(app_index: u64, reviewer: vector<u8>, review: vector<u8>, status: u8) 
  ensure reviewer == txn.sender() {  // Only allow review by authorized person
  // Fetch the Incubation Center instance from storage
  let mut incubation_center = storage::load(SocialIncubation::KEY) as SocialIncubation;

  // Check if application index is within bounds
  assert(app_index < incubation_center.applications.length() as u64, 
         INVALID_APPLICATION_INDEX);

  // Update the application with review and status
  let mut application = &mut incubation_center.applications[app_index as usize];
  application.reviewer = reviewer;
  application.review = review;
  application.status = status;

  // Save the updated state to storage
  storage::save(incubation_center, SocialIncubation::KEY);
}

// Constants and accessors
const INVALID_APPLICATION_INDEX: u64 = 1;

public exposes get_applications(): vector<Application> {
  let incubation_center = storage::load(SocialIncubation::KEY) as SocialIncubation;
  incubation_center.applications
}

public exposes get_admin(): vector<u8> {
  let incubation_center = storage::load(SocialIncubation::KEY) as SocialIncubation;
  incubation_center.admin
}                                                                                               
// Public access to a list of applications (without revealing reviewer identity or private details)
 
 