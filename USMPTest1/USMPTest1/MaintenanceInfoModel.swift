//
//  MaintenanceInfoModel.swift
//  USMPTest1
//
//  Object that holds all info for the Maintenance Form
//
//  Created by Colleen Rothe on 11/26/16.
//  Copyright © 2016 Colleen Rothe. All rights reserved.
//

//adapted from:
//http://codewithchris.com/iphone-app-connect-to-mysql-database/

import Foundation

class MaintenanceInfoModel: NSObject{
    var id: String?
    var site_id : String?
    var code_relation: String?
    var maintenance_type: String?
    var rtNum: String?
    var beginMile: String?
    var endMile: String?
    var agency: String?
    var regional: String?
    var local: String?
    var us_event: String?
    var event_desc: String?
    var design_pse: String?
    var remove_ditch: String?
    var remove_road_trail: String?
    var relevel_aggregate: String?
    var relevel_patch: String?
    var drainage_improvement: String?
    var deep_patch: String?
    var haul_debris: String?
    var scaling_rock_slopes: String?
    var road_trail_alignment: String?
    var repair_rockfall_barrier: String?
    var repair_rockfall_netting: String?
    var sealing_cracks: String?
    var guardrail: String?
    var cleaning_drains: String?
    var flagging_signing: String?
    var others1_desc: String?
    var others1: String?
    var others2_desc: String?
    var others2: String?
    var others3_desc: String?
    var others3: String?
    var others4_desc: String?
    var others4: String?
    var others5_desc: String?
    var others5: String?
    var total: String?
    var total_percent: String?
    
    var design_pse_val: String?
    var remove_ditch_val: String?
    var remove_road_trail_val: String?
    var relevel_aggregate_val: String?
    var relevel_patch_val: String?
    var drainage_improvement_val: String?
    var deep_patch_val: String?
    var haul_debris_val: String?
    var scaling_rock_slopes_val: String?
    var road_trail_alignment_val: String?
    var repair_rockfall_barrier_val: String?
    var repair_rockfall_netting_val: String?
    var sealing_cracks_val: String?
    var guardrail_val: String?
    var cleaning_drains_val: String?
    var flagging_signing_val: String?
    
    var others1_val: String?
    var others2_val: String?
    var others3_val: String?
    var others4_val: String?
    var others5_val: String?

    override init(){
        
    }
    
    init(id: String,site_id : String, code_relation: String, maintenance_type: String, rtNum: String, beginMile: String, endMile: String, agency: String, regional: String, local: String, us_event: String, event_desc: String, design_pse: String, remove_ditch: String, remove_road_trail: String, relevel_aggregate: String, relevel_patch: String, drainage_improvement: String, deep_patch: String, haul_debris: String, scaling_rock_slopes: String, road_trail_alignment: String, repair_rockfall_barrier: String, repair_rockfall_netting: String, sealing_cracks: String, guardrail: String, cleaning_drains: String, flagging_signing: String, others1_desc: String, others1: String, others2_desc: String, others2: String, others3_desc: String, others3: String, others4_desc: String, others4: String, others5_desc: String, others5: String, total: String, total_percent: String, design_pse_val: String, remove_ditch_val: String, remove_road_trail_val: String, relevel_aggregate_val: String, relevel_patch_val: String, drainage_improvement_val: String, deep_patch_val: String, haul_debris_val: String, scaling_rock_slopes_val: String, road_trail_alignment_val: String, repair_rockfall_barrier_val: String, repair_rockfall_netting_val: String, sealing_cracks_val: String, guardrail_val: String, cleaning_drains_val: String, flagging_signing_val: String, others1_val: String, others2_val: String, others3_val: String, others4_val: String, others5_val: String){
        
        self.id = id
        self.site_id = site_id
        self.code_relation = code_relation
        self.maintenance_type = maintenance_type
        self.rtNum = rtNum
        self.beginMile = beginMile
        self.endMile = endMile
        self.agency = agency
        self.regional = regional
        self.local = local
        self.us_event = us_event
        self.event_desc = event_desc
        self.design_pse = design_pse
        self.remove_ditch = remove_ditch
        self.remove_road_trail = remove_road_trail
        self.relevel_aggregate = relevel_aggregate
        self.relevel_patch = relevel_patch
        self.drainage_improvement = drainage_improvement
        self.deep_patch = deep_patch
        self.haul_debris = haul_debris
        self.scaling_rock_slopes = scaling_rock_slopes
        self.road_trail_alignment = road_trail_alignment
        self.repair_rockfall_barrier = repair_rockfall_barrier
        self.repair_rockfall_netting = repair_rockfall_netting
        self.sealing_cracks = sealing_cracks
        self.guardrail = guardrail
        self.cleaning_drains = cleaning_drains
        self.flagging_signing = flagging_signing
        self.others1_desc = others1_desc
        self.others1 = others1
        self.others2_desc = others2_desc
        self.others2 = others2
        self.others3_desc = others3_desc
        self.others3 = others3
        self.others4_desc = others4_desc
        self.others4 = others4
        self.others5_desc = others5_desc
        self.others5 = others5
        self.total = total
        self.total_percent = total_percent
        
        
        self.design_pse_val = design_pse_val
        self.remove_ditch_val = remove_ditch_val
        self.remove_road_trail_val = remove_road_trail_val
        self.relevel_aggregate_val = relevel_aggregate_val
        self.relevel_patch_val = relevel_patch_val
        self.drainage_improvement_val = drainage_improvement_val
        self.deep_patch_val = deep_patch_val
        self.haul_debris_val = haul_debris_val
        self.scaling_rock_slopes_val = scaling_rock_slopes_val
        self.road_trail_alignment_val = road_trail_alignment_val
        self.repair_rockfall_barrier_val = repair_rockfall_barrier_val
        self.repair_rockfall_netting_val = repair_rockfall_netting_val
        self.sealing_cracks_val = sealing_cracks_val
        self.guardrail_val = guardrail_val
        self.cleaning_drains_val = cleaning_drains_val
        self.flagging_signing_val = flagging_signing_val
        self.others1_val = others1_val
        self.others2_val = others2_val
        self.others3_val = others3_val
        self.others4_val = others4_val
        self.others5_val = others5_val
        
    }
}
