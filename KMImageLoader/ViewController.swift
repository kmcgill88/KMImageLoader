//
//  ViewController.swift
//  KMImageLoader
//
//  Created by Kevin McGill on 3/19/15.
//  Copyright (c) 2015 McGill DevTech, LLC. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let urls = ["https://farm6.staticflickr.com/5512/11396424953_b35cc92dff_b.jpg", "https://farm6.staticflickr.com/5537/11554128305_153f449823_b.jpg", "https://farm8.staticflickr.com/7340/10273619965_e81c9a3b07_b.jpg", "https://farm3.staticflickr.com/2811/11554126604_b1d219c1bb_b.jpg", "https://farm6.staticflickr.com/5525/11554245593_5d8be9d7c1_b.jpg", "https://farm8.staticflickr.com/7368/11554107355_1192ceaf59_b.jpg", "https://farm8.staticflickr.com/7385/11554151854_6e9b2406dc_b.jpg", "https://farm4.staticflickr.com/3675/11554261166_13a476c641_b.jpg", "https://farm6.staticflickr.com/5487/11554136645_f652330fc1_b.jpg", "https://farm6.staticflickr.com/5521/11554284213_dd42d06fe3_b.jpg", "https://farm3.staticflickr.com/2849/11554279626_5e264dc621_b.jpg", "https://farm4.staticflickr.com/3687/11554195234_579462672f_b.jpg", "https://farm6.staticflickr.com/5499/11554303016_5173d3538c_b.jpg", "https://farm4.staticflickr.com/3788/11554175495_0a557fb91a_b.jpg", "https://farm8.staticflickr.com/7443/11554332193_193cb1d245_b.jpg", "https://farm6.staticflickr.com/5483/11554189025_aefa5dc0ca_b.jpg", "https://farm4.staticflickr.com/3682/11554341223_2dc6a2abb0_b.jpg", "https://farm3.staticflickr.com/2858/11554349113_8c6c8009d3_b.jpg", "https://farm4.staticflickr.com/3693/11554246204_179d51af43_b.jpg", "https://farm6.staticflickr.com/5480/11554256674_dab2e93892_b.jpg", "https://farm8.staticflickr.com/7427/11554369953_84efbc2d0a_b.jpg", "https://farm3.staticflickr.com/2810/11554378316_8a69451c2e_b.jpg", "https://farm6.staticflickr.com/5503/11554288644_f9a62c672d_b.jpg", "https://farm8.staticflickr.com/7304/11554395916_331ba50db2_b.jpg", "https://farm4.staticflickr.com/3717/11554412163_ba53677213_b.jpg", "https://farm3.staticflickr.com/2889/11554270045_d9a725e2fa_b.jpg", "https://farm4.staticflickr.com/3742/11554321504_8b35d1c69f_b.jpg", "https://farm8.staticflickr.com/7417/11554431153_c6145de6e3_b.jpg", "https://farm4.staticflickr.com/3790/11554299595_59dc2801b1_b.jpg", "https://farm4.staticflickr.com/3756/11554339804_ec2ee3695e_b.jpg", "https://farm8.staticflickr.com/7313/11554450576_4ef1c7a4a8_b.jpg", "https://farm4.staticflickr.com/3806/11554659484_a4fbdaa15a_b.jpg" , "https://farm4.staticflickr.com/3767/11554769503_666cae523b_b.jpg", "https://farm3.staticflickr.com/2814/11554673924_8c7334b2cf_b.jpg", "https://farm6.staticflickr.com/5491/11554691754_61da2f3e12_b.jpg", "https://farm4.staticflickr.com/3670/11554824153_1ebbd0c058_b.jpg"]

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urls.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "testCell")
        var url = urls[indexPath.row]
        cell.imageView!.image = UIImage(named: "loading-placeholder-clear.png")
        ImageLoader.sharedLoader.imageForUrl(url, completionHandler:{(image: UIImage!, url: String) in
            cell.imageView!.image = image
        })

        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
}

