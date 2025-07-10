// data/campaign_dummy_data.dart
import '../models/campaign_model.dart';

class CampaignDummyData {
  static CampaignData getCampaignData() {
    return CampaignData(
      dateRange: "30 Dec, 2024 - 30 Jan, 2025",
      activeCampaignCount: 4,
      liveCampaigns: [
        Campaign(
          id: "1",
          title: "Health Check-Up Promo",
          percentage: 70.0,
          impressions: "25K",
          impressionCount: 25000,
        ),
        Campaign(
          id: "2",
          title: "Diabetic Care Awareness",
          percentage: 60.0,
          impressions: "18K",
          impressionCount: 18000,
        ),
        Campaign(
          id: "3",
          title: "Free Dental Consultation",
          percentage: 80.0,
          impressions: "22K",
          impressionCount: 22000,
        ),
        Campaign(
          id: "4",
          title: "Senior Health Package",
          percentage: 86.0,
          impressions: "30K",
          impressionCount: 30000,
        ),
      ],
      campaignAnalysis: [
        CampaignAnalysis(
          campaignName: "Campaign A",
          reach: 25.0,
          budget: 20.0,
          rate: 12.0,
        ),
        CampaignAnalysis(
          campaignName: "Campaign B",
          reach: 18.0,
          budget: 18.0,
          rate: 8.0,
        ),
        CampaignAnalysis(
          campaignName: "Campaign C",
          reach: 22.0,
          budget: 10.0,
          rate: 15.0,
        ),
        CampaignAnalysis(
          campaignName: "Campaign D",
          reach: 30.0,
          budget: 10.0,
          rate: 10.0,
        ),
      ],
      visitorProfile: [
        VisitorProfile(gender: "Male", percentage: 55.0),
        VisitorProfile(gender: "Female", percentage: 45.0),
      ],
    );
  }
}