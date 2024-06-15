//Smart Contract for by implementing  features like adding milestones, funding mechanisms, or tokenization for incubation center operations


// File: SocialIncubation.move

// Define the applicant structure with basic information
struct Applicant {
  pub name: vector<u8>,
  pub social_media_handle: vector<u8>,
  pub idea_description: vector<u8>,
}

// Define a milestone struct
struct Milestone {
  pub description: vector<u8>,
  pub deadline: u64, // Unix timestamp for deadline
  pub completed: bool,
}

// Define the application struct with review, status, funding, and milestones fields
struct Application {
  pub applicant: Applicant,
  pub reviewer: vector<u8>, // Stores the reviewer's wallet address
  pub review: vector<u8>,   // Stores the review text
  pub status: u8,           // 0: Pending, 1: Accepted, 2: Rejected
  pub funding: u64,         // Amount of funding requested
  pub milestones: vector<Milestone>,
}

// Define a funding struct (optional for future implementation)
struct Funding {
  pub amount: u64,
  pub investor: vector<u8>, // Investor's wallet address (if applicable)
}

// Manage the Incubation Center state
struct SocialIncubation {
  pub admin: vector<u8>,       // Stores the admin wallet address
  pub applications: vector<Application>,
  pub token: Option<vector<u8>>, // Stores the token address (if using tokenization)
}

// Constants and accessors
const INVALID_APPLICATION_INDEX: u64 = 1;

public entrypoint init(admin: vector<u8>) {
  // Create a new Incubation Center instance
  let incubation_center = SocialIncubation {
    admin: admin,
    applications: vec!(),
    token: None,
  };
  storage::save(incubation_center, SocialIncubation::KEY);
}

public fun apply(applicant: Applicant, funding: u64, milestones: vector<Milestone>) {
  // Fetch the Incubation Center instance from storage
  let mut incubation_center = storage::load(SocialIncubation::KEY) as SocialIncubation;

  // Add the new application with funding and milestones
  incubation_center.applications.push(Application {
    applicant: applicant,
    reviewer: vec!(),
    review: vec!(),
    status: 0,
    funding: funding,
    milestones: milestones,
  });

  // Save the updated state to storage
  storage::save(incubation_center, SocialIncubation::KEY);
}

// Function to review application with milestone tracking (optional funding update)
public fun review(
  app_index: u64,
  reviewer: vector<u8>,
  review: vector<u8>,
  status: u8,
  // Optional funding update
  funding_update: Option<u64>,
) ensures reviewer == txn.sender() {
  // Fetch the Incubation Center instance from storage
  let mut incubation_center = storage::load(SocialIncubation::KEY) as SocialIncubation;

  // Check if application index is within bounds
  assert(app_index < incubation_center.applications.length() as u64,
         INVALID_APPLICATION_INDEX);

  // Update the application with review, status, and potentially funding
  let mut application = &mut incubation_center.applications[app_index as usize];
  application.reviewer = reviewer;
  application.review = review;
  application.status = status;
  if funding_update.is_some() {
    application.funding = funding_update.unwrap();
  }

  // Save the updated state to storage
  storage::save(incubation_center, SocialIncubation::KEY);
}

// Function to mark a milestone as completed (optional)
public fun mark_milestone_complete(app_index: u64, milestone_index: u64) {
  // Fetch the Incubation Center instance from storage
  let mut incubation_center = storage::load(SocialIncubation::KEY) as SocialIncubation;

  // Check if application and milestone index are within bounds
  assert(app_index < incubation_center.applications.length() as u64,
         INVALID_APPLICATION_INDEX);
  let application = &incubation_center.applications[app_index as usize];
  assert(milestone_index < application.milestones.length() as u64,
         
