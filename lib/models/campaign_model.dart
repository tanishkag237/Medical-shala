// models/campaign_model.dart

class Campaign {
  final String id;
  final String title;
  final double percentage;
  final String impressions;
  final int impressionCount;

  Campaign({
    required this.id,
    required this.title,
    required this.percentage,
    required this.impressions,
    required this.impressionCount,
  });
}

class CampaignAnalysis {
  final String campaignName;
  final double reach;
  final double budget;
  final double rate;

  CampaignAnalysis({
    required this.campaignName,
    required this.reach,
    required this.budget,
    required this.rate,
  });
}

class VisitorProfile {
  final String gender;
  final double percentage;

  VisitorProfile({
    required this.gender,
    required this.percentage,
  });
}

class CampaignData {
  final List<Campaign> liveCampaigns;
  final List<CampaignAnalysis> campaignAnalysis;
  final List<VisitorProfile> visitorProfile;
  final String dateRange;
  final int activeCampaignCount;

  CampaignData({
    required this.liveCampaigns,
    required this.campaignAnalysis,
    required this.visitorProfile,
    required this.dateRange,
    required this.activeCampaignCount,
  });
}