import '../../../../core/utils/app_images.dart';

enum MiniAuctionFranchiseEnum {csk, mi, kkr, srh, rcb}

extension MiniAuctionFranchiseExtension on MiniAuctionFranchiseEnum{
  String image(){
    switch(this){
      case MiniAuctionFranchiseEnum.csk:
        return AppImages.csk;
      case MiniAuctionFranchiseEnum.mi:
        return AppImages.mi;
      case MiniAuctionFranchiseEnum.kkr:
        return AppImages.kkr;
      case MiniAuctionFranchiseEnum.srh:
        return AppImages.srh;
      case MiniAuctionFranchiseEnum.rcb:
        return AppImages.rcb;
    }
  }

  String fullName(){
    switch(this){
      case MiniAuctionFranchiseEnum.csk:
        return 'CHENNAI SUPREME KINGS';
      case MiniAuctionFranchiseEnum.mi:
        return 'MUMBAI IGNITES';
      case MiniAuctionFranchiseEnum.kkr:
        return 'KOLKATA KNIGHT ROCKERS';
      case MiniAuctionFranchiseEnum.srh:
        return 'STORMRISERS HYDERABAD';
      case MiniAuctionFranchiseEnum.rcb:
        return 'ROYAL CHAMPIONS BENGALURU';
    }
  }
}