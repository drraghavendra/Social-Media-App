// This contract defines a IncubationCenter resource to store relevant data.
// It includes functions for:
// Admin adding startups
// Startups adding milestones
// Admin marking milestones complete (placeholder for actual logic)
// Admin distributing funds based on milestones
// Startups viewing their funding amount
// The contract utilizes access control to ensure only the admin can perform specific actions.
// The get_funding function allows enrolled startups to view their allocated funds.




// Define resource for storing incubation center data
struct IncubationCenter {
  // Admin account address for managing the center
  admin: address;

  // List of enrolled startups (account addresses)
  startups: vector<address>;

  // Mapping of startup address to its milestones
  milestones: map<address, vector<string>>;

  // Mapping of startup address to its funding amount
  funding: map<address, u64>;

  // Total funds available for distribution (managed by admin)
  total_funds: u64;
}

// Public function for the admin to add a startup
public fun add_startup(admin: &mut Self, new_startup: address) {
  // Check if caller is admin
  assert!(admin == self.admin, "Only admin can add startups");

  // Add startup to list
  self.startups.push_back(new_startup);
}

// Public function for a startup to add a milestone
public fun add_milestone(startup: &mut Self, milestone: string) {
  // Check if startup is enrolled
  assert!(self.startups.contains(sender()), "Only enrolled startups can add milestones");

  // Add milestone to startup's list
  self.milestones.borrow_mut(sender()).push_back(milestone);
}

// Public function for admin to mark a milestone as completed
public fun mark_milestone_complete(admin: &mut Self, startup: address, milestone_index: u64) {
  // Check if caller is admin
  assert!(admin == self.admin, "Only admin can mark milestones complete");

  // Check if startup is enrolled
  assert!(self.startups.contains(startup), "Startup not enrolled");

  // Check if milestone index is valid
  let milestones = self.milestones.borrow(startup);
  assert!(milestone_index < milestones.len(), "Invalid milestone index");

  // Mark milestone as complete (placeholder for actual logic)
  // You can implement logic to track completion status here (e.g., bool flag)
}

// Public function for admin to distribute funds based on milestones
public fun distribute_funds(admin: &mut Self, startup: address, amount: u64) {
  // Check if caller is admin
  assert!(admin == self.admin, "Only admin can distribute funds");

  // Check if startup is enrolled
  assert!(self.startups.contains(startup), "Startup not enrolled");

  // Check if sufficient funds available
  assert!(amount <= self.total_funds, "Insufficient funds");

  // Reduce total funds and update startup's funding
  self.total_funds -= amount;
  self.funding.insert(startup, self.funding.get(startup).unwrap_or(0) + amount);

  // Simulate token transfer (replace with actual Petra wallet integration)
  // petra_wallet.transfer(startup, amount); // This is not Move syntax, just a placeholder
}

// Public function for a startup to view its funding amount
public fun get_funding(startup: &mut Self): u64 {
  // Check if startup is enrolled
  assert!(self.startups.contains(sender()), "Only enrolled startups can view funding");

  return self.funding.get(sender()).unwrap_or(0);
}
