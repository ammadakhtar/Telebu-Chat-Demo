//
//  ChatViewController.swift
//  TelebuChat
//
//  Created by Ammad on 12/08/2021.
//

import UIKit
import Foundation

final class CustomChatViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlets and variables
    
    @IBOutlet weak var inputToolBarView: UIView!
    @IBOutlet weak var inputBarView: UIView!
    @IBOutlet weak var inputTextView: PlaceholderTextView!
    @IBOutlet weak var inputBarStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputToolbarBottomConstraint : NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var addMediaButton: UIButton!
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        return activityIndicator
    }()
    
    var viewModel: CustomChatViewModel
    var isLoading = true
    var isPagination = false
    var offSet = 0
    var isShowingReaction = false
    var reactionIndexPath: IndexPath?
    var oldTableViewHeight: CGFloat = 0.0
    
    // MARK: - UIVIewController LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllerUI()
        inputTextView.autocorrectionType = .yes
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // To detect when keyboard is going to dismiss
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // To detect when keyboard is going to appear
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.applyGradient(colors: [#colorLiteral(red: 0.1059900746, green: 0.5370061398, blue: 0.8431327939, alpha: 1).cgColor, #colorLiteral(red: 0.3570215702, green: 0.6886960864, blue: 0.7840443254, alpha: 1).cgColor], locations: [0.0, 1.0], direction: .leftToRight, halfHeight: true)
        inputBarView.layer.cornerRadius = 17.5
        inputBarView.layer.masksToBounds = true
        
        addMediaButton.applyGradient(colors: [#colorLiteral(red: 0.3476788998, green: 0.4778687954, blue: 0.7855350375, alpha: 1).cgColor, #colorLiteral(red: 0.7083157897, green: 0.4169446826, blue: 0.6948504448, alpha: 1).cgColor], locations: [0.0, 1.0], direction: .leftToRight)
    }
    
    init(viewModel: CustomChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // MARK: - Custom Methods
    
    func setupViewControllerUI() {
        tableView.keyboardDismissMode = .onDrag
        tableView.register(cellType: InComingChatTableViewCell.self)
        tableView.register(cellType: OutGoingChatTableViewCell.self)
        
        inputTextView.delegate = self
        inputTextView.textContainerInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        activityIndicator.center = self.tableView.center
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)
    }
    
    func setupViewModel() {
        viewModel.showAlertClosure = { [weak self] in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert(message)
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {

                if self.viewModel.messages.count > 0 && !self.isPagination {
                    self.tableView.scrollToBottom()
                } else {
                    UIView.performWithoutAnimation{
                        //Step 1 Detect & Store
                        // using 30 here since our fetch limit is 30
                        let topWillBeAt = self.getTopVisibleRow() + 30
                        let oldHeightDifferenceBetweenTopRowAndNavBar = self.heightDifferenceBetweenTopRowAndNavBar()
                        
                        //Step 2 Insert
                        self.tableView.reloadData()
                        
                        //Step 3 Restore Scrolling
                        self.tableView.scrollToRow(at: IndexPath(row: topWillBeAt, section: 0), at: .top, animated: false)
                        self.tableView.contentOffset.y = self.tableView.contentOffset.y - oldHeightDifferenceBetweenTopRowAndNavBar
                        
                    }
                }
                self.isPagination = false
                self.isLoading = false
            }
        }
        viewModel.initFetch(offSet: offSet, isPagination: isPagination)
    }
    
    func getTopVisibleRow () -> Int {
        let pointWhereNavBarEnds = CGPoint(x: 0, y: 155)
        let accurateIndexPath = tableView.indexPathForRow(at: pointWhereNavBarEnds)
        return accurateIndexPath?.row ?? 0
    }
    
    func heightDifferenceBetweenTopRowAndNavBar()-> CGFloat{
        let rectForTopRow = tableView.rectForRow(at:IndexPath(row:  getTopVisibleRow(), section: 0))
        let pointWhereNavBarEnds = CGPoint(x: 0, y: 155)
        let differenceBetweenTopRowAndNavBar = rectForTopRow.origin.y - pointWhereNavBarEnds.y
        return differenceBetweenTopRowAndNavBar
        
    }
    
    @objc func keyboardWillAppear(_ notification : Notification) {
        if let keyboard = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue , let _ = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            if viewModel.messages.count > 0 {
                self.tableView.scrollToBottom()
            }
            let keyboardHeight = keyboard.cgRectValue.height
            if Utility.hasTopNotch {
                self.inputToolbarBottomConstraint.constant = keyboardHeight - 25
            } else {
                self.inputToolbarBottomConstraint.constant = keyboardHeight + 5
            }
            self.updateLayoutForView(view: self.inputToolBarView)
            self.updateLayoutForView(view: self.tableView)
        }
    }
    
    @objc func keyboardWillDisappear(_ notification : Notification) {
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            self.inputToolbarBottomConstraint.constant = 5
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func didTapReactionButton(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        // get cell from the indexpath
        if let cell = tableView.cellForRow(at: indexPath) as? InComingChatTableViewCell {
            // check if a reaction view is already visible, and user is trying to open reactionView for another cell
            if isShowingReaction && reactionIndexPath != nil && reactionIndexPath != indexPath {
                // remove the reaction view from previous cell
                let reactionCell = tableView.cellForRow(at: reactionIndexPath!) as? InComingChatTableViewCell
                reactionCell?.removeReactionContainerView()
                isShowingReaction = false
            }
            
            // If reaction view is visible, hide it
            if isShowingReaction {
                cell.removeReactionContainerView()
                isShowingReaction = false
            } else {
                // add the reactionView in contentView of cell
                cell.addReactionContainerView()
                isShowingReaction = true
                reactionIndexPath = indexPath
            }
        }
    }
    
    func updateLayoutForView(view: UIView) {
        DispatchQueue.main.async {
            view.layoutIfNeeded()
            view.layoutSubviews()
            view.setNeedsDisplay()
        }
    }
    
    private func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension CustomChatViewController {
    
    // MARK: - UITableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.getCellViewModel(at: indexPath)
        // Other's Messages
        if cellViewModel.userId == "1" {
            let cell = tableView.dequeue(cellType: InComingChatTableViewCell.self)
            cell.inComingChatCellUIModel = cellViewModel
            cell.reactionButton.tag = indexPath.row
            cell.reactionButton.addTarget(self, action: #selector(didTapReactionButton), for: .touchUpInside)
            return cell
        }
        // My Messages
        let cell = tableView.dequeue(cellType: OutGoingChatTableViewCell.self)
        cell.outgoingChatCellUIModel = cellViewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // hide reaction view when user taps on the empty area in the tableView
        if let reactionIndexPath = reactionIndexPath {
            let reactionCell = tableView.cellForRow(at: reactionIndexPath) as? InComingChatTableViewCell
            reactionCell?.removeReactionContainerView()
            isShowingReaction = false
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 5 && !isLoading && viewModel.numberOfRows < 60 {
            isPagination = true
            isLoading = true
            offSet = offSet + 30
            oldTableViewHeight = self.tableView.contentSize.height;
            viewModel.initFetch(offSet: offSet, isPagination: isPagination)
        }
    }
}

extension CustomChatViewController: UITextViewDelegate {
    
    //  MARK: - UITextView Delegate
    
    func textViewDidChange(_ textView: UITextView) {
        // Max height of textView
        if textView.contentSize.height >= 100 {
            textView.frame.size.height = 100
            textView.isScrollEnabled = true
        } else if textView.text.isEmpty {
            textView.isScrollEnabled = false
            textView.frame.size.height = 40.0
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        } else {
            textView.frame.size.height = textView.contentSize.height
            textView.isScrollEnabled = false
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
}

