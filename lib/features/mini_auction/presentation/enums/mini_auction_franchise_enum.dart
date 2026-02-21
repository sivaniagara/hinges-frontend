import '../../../../core/utils/app_images.dart';

enum MiniAuctionFranchiseEnum {csk, mi, kkr, srh, rcb, empty}

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
      case MiniAuctionFranchiseEnum.empty:
        return 'empty image';
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
      case MiniAuctionFranchiseEnum.empty:
        return ' - ';
    }
  }
  String shortName(){
    switch(this){
      case MiniAuctionFranchiseEnum.csk:
        return 'CSK';
      case MiniAuctionFranchiseEnum.mi:
        return 'MI';
      case MiniAuctionFranchiseEnum.kkr:
        return 'KKR';
      case MiniAuctionFranchiseEnum.srh:
        return 'SRH';
      case MiniAuctionFranchiseEnum.rcb:
        return 'RCB';
      case MiniAuctionFranchiseEnum.empty:
        return ' - ';
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
      case MiniAuctionFranchiseEnum.empty:
        return ' - ';
    }
  }

  MiniAuctionFranchiseEnum teamEnum(String teamId){
    switch(teamId){
      case '68807887cdb3a1195b5a1fd1':
        return MiniAuctionFranchiseEnum.csk;
      case '688078e2cdb3a1195b5a1fd4':
        return MiniAuctionFranchiseEnum.mi;
      case '68807861cdb3a1195b5a1fd0':
        return MiniAuctionFranchiseEnum.kkr;
      case '688078c5cdb3a1195b5a1fd3':
        return MiniAuctionFranchiseEnum.srh;
      case '688078a7cdb3a1195b5a1fd2':
        return MiniAuctionFranchiseEnum.rcb;
      default:
        return MiniAuctionFranchiseEnum.empty;
    }
  }
}