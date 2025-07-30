//
//  SettingViewController.swift
//  Solitaire
//
//  Created by Smit Gandhi on 08/07/25.
//

import UIKit

class SettingViewController: UIViewController {
    enum SettingsSection {
        case sound
        case vibration
        case testing
        case legal
        case customization
        case blankCell
    }
    
    enum SettingsItem {
        case toggle(title: String, isOn: Bool)
        case button(title: String, color: UIColor, id: String)
        case blankItem
    }
    
    @IBOutlet weak var tblView: UITableView!
    private var settings: [(section: SettingsSection, items: [SettingsItem])] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.backgroundColor = AppConstants.Colors.BackGround
        self.navigationItem.title = "Settings"
        
        // Do any additional setup after loading the view.
        setupData()
        setupTableView()
    }
    
    private func setupData() {
        settings = [
            (.sound, [.toggle(title: "Sound", isOn: true)]),
            (.vibration, [.toggle(title: "Vibration", isOn: true)]),
            (.testing, [.toggle(title: "Testing", isOn: true)]),
            (.legal, [
                .button(title: "Terms & Conditions", color: .black, id: "T&C"),
                .button(title: "Privacy Policy", color: .black, id: "PP")
            ]),
            (.customization, [
                .button(title: "Change Card", color: UIColor.systemOrange, id: "ChangeCard"),
                .button(title: "Change Background", color: UIColor.systemOrange, id: "ChangeBackground")
            ]),
            (.blankCell, [.blankItem,
                          .blankItem])
        ]
    }
    
    private func setupTableView() {
        tblView.delegate = self
        tblView.dataSource = self
        tblView.separatorStyle = .none
        tblView.register(SwitchCell.self, forCellReuseIdentifier: "SwitchCell")
        tblView.register(ButtonCell.self, forCellReuseIdentifier: "ButtonCell")
    }
    
    private func openCardSelection() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CardSelectionViewController") as! CardSelectionViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch settings[section].section {
        case .sound: return "Sound Settings"
        case .vibration: return "Vibration Settings"
        case .testing: return "Testing"
        case .legal: return "Legal"
        case .customization: return "Customization"
        case .blankCell: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = settings[indexPath.section].items[indexPath.row]
        
        switch item {
        case .toggle(let title, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            if settings[indexPath.section].section == SettingsSection.sound {
                cell.configure(
                    with: title,
                    isOn: AppConstants.AppConfigurations.isSoundEnable,
                    symbolName: "speaker.wave.2.fill"
                ) { newValue in
                    AppConstants.AppConfigurations.isSoundEnable = newValue
                    print("Sound toggled: \(newValue)")
                }
            }else if settings[indexPath.section].section == SettingsSection.vibration {
                cell.configure(
                    with: title,
                    isOn: AppConstants.AppConfigurations.isVibrationEnable,
                    symbolName: "iphone.radiowaves.left.and.right"
                ) { newValue in
                    AppConstants.AppConfigurations.isVibrationEnable = newValue
                    print("Vibration toggled: \(newValue)")
                }
            }else{
                cell.configure(
                    with: title,
                    isOn: AppConstants.AppConfigurations.testModeEnabled,
                    symbolName: ""
                ) { newValue in
                    AppConstants.AppConfigurations.testModeEnabled = newValue
                    print("Demo toggled: \(newValue)")
                }
            }
            return cell
            
        case .button(let title, let color, let id):
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            if settings[indexPath.section].section == SettingsSection.legal {
                cell.button.appPrimaryButton(isEnable: true, title: title, titleFont: AppConstants.Fonts.MarkerFeltThin_16!)
                cell.button.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            }else{
                cell.button.appPrimaryButton(isEnable: true, title: title, titleFont: AppConstants.Fonts.MarkerFeltThin_16!)
            }
            
            cell.buttonAction = { [weak self] in
                switch id {
                case "T&C":
                    print("Open Terms & Conditions screen")
                    // self?.openTerms()
                case "PP":
                    print("Open Privacy Policy screen")
                    // self?.openPrivacyPolicy()
                case "ChangeCard":
                    print("Open Change Card screen")
                     self?.openCardSelection()
                case "ChangeBackground":
                    print("Open Change Background screen")
                    // self?.openBackgroundPicker()
                default:
                    break
                }
            }
            cell.button.layer.cornerRadius = 22
            return cell
        case .blankItem:
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            return cell
        }
    }
}

