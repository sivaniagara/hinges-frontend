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

  String teamId(){
    switch(this){
      case MiniAuctionFranchiseEnum.csk:
        return '68807887cdb3a1195b5a1fd1';
      case MiniAuctionFranchiseEnum.mi:
        return '688078e2cdb3a1195b5a1fd4';
      case MiniAuctionFranchiseEnum.kkr:
        return '68807861cdb3a1195b5a1fd0';
      case MiniAuctionFranchiseEnum.srh:
        return '688078c5cdb3a1195b5a1fd3';
      case MiniAuctionFranchiseEnum.rcb:
        return '688078a7cdb3a1195b5a1fd2';
    }
  }
}