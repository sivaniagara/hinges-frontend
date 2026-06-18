import '../../../../core/utils/app_images.dart';

enum MiniAuctionFranchiseEnum {csk, mi, kkr, srh, rcb, gt, rr, dc, lsg, pk, empty}

extension MiniAuctionFranchiseExtension on MiniAuctionFranchiseEnum{
  String image(){
    switch(this){
      case MiniAuctionFranchiseEnum.csk:
        return AppImages.cskLogo;
      case MiniAuctionFranchiseEnum.mi:
        return AppImages.miLogo;
      case MiniAuctionFranchiseEnum.kkr:
        return AppImages.kkrLogo;
      case MiniAuctionFranchiseEnum.srh:
        return AppImages.srhLogo;
      case MiniAuctionFranchiseEnum.rcb:
        return AppImages.rcbLogo;
      case MiniAuctionFranchiseEnum.gt:
        return AppImages.gtLogo;
      case MiniAuctionFranchiseEnum.rr:
        return AppImages.rrLogo;
      case MiniAuctionFranchiseEnum.dc:
        return AppImages.dcLogo;
      case MiniAuctionFranchiseEnum.lsg:
        return AppImages.lsgLogo;
      case MiniAuctionFranchiseEnum.pk:
        return AppImages.pkLogo;
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
      case MiniAuctionFranchiseEnum.gt:
        return 'GUJARAT THUNDERS';
      case MiniAuctionFranchiseEnum.rr:
        return 'RAJASTHAN RANGERS';
      case MiniAuctionFranchiseEnum.dc:
        return 'DELHI COMBATS';
      case MiniAuctionFranchiseEnum.lsg:
        return 'LUCKNOW SUPER GALLANTS';
      case MiniAuctionFranchiseEnum.pk:
        return 'PUNJAB KINETICS';
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
      case MiniAuctionFranchiseEnum.gt:
        return 'GT';
      case MiniAuctionFranchiseEnum.rr:
        return 'RR';
      case MiniAuctionFranchiseEnum.dc:
        return 'DC';
      case MiniAuctionFranchiseEnum.lsg:
        return 'LSG';
      case MiniAuctionFranchiseEnum.pk:
        return 'PK';
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
      case MiniAuctionFranchiseEnum.gt:
        return '6a1ff64a7e31be3c41b99846';
      case MiniAuctionFranchiseEnum.rr:
        return '6a1ff6587e31be3c41b99847';
      case MiniAuctionFranchiseEnum.dc:
        return '6a1ff6717e31be3c41b99848';
      case MiniAuctionFranchiseEnum.lsg:
        return '6a1ff67f7e31be3c41b99849';
      case MiniAuctionFranchiseEnum.pk:
        return '6a2020367e31be3c41b9984a';
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
      case '6a1ff64a7e31be3c41b99846':
        return MiniAuctionFranchiseEnum.gt;
      case '6a1ff6587e31be3c41b99847':
        return MiniAuctionFranchiseEnum.rr;
      case '6a1ff6717e31be3c41b99848':
        return MiniAuctionFranchiseEnum.dc;
      case '6a1ff67f7e31be3c41b99849':
        return MiniAuctionFranchiseEnum.lsg;
      case '6a2020367e31be3c41b9984a':
        return MiniAuctionFranchiseEnum.pk;
      default:
        return MiniAuctionFranchiseEnum.empty;
    }
  }
}