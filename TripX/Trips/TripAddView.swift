//
//  TripAddView.swift
//  TripX
//
//  Created by JL on 2022/3/21.
//

import SwiftUI
import AlertToast

struct TripAddView: View {
    
    // https://developer.apple.com/documentation/swiftui/environmentvalues/ispresented
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var viewmodel: TripViewModel

    @State var trip: Trip = Trip(name: "", start: Date(), end: Date(), location: "", imageURL: "")

    @State private var nameWrong = false
    @State private var startDateWrong = false
    @State private var endDateWrong = false
    @State private var locationWrong = false

    @State private var inputImage: UIImage = UIImage(systemName: "photo.fill")!
    @State private var showingPickPhotoActionSheet: Bool = false
    @State private var showingPickFromCameraSheet: Bool = false
    @State private var showingPickFromAlbumSheet: Bool = false
    

    @State private var showAddTripSuccess: Bool = false
    
    var body: some View {
        ScrollView {
            Group {
                Section {
                    VStack(alignment: .leading) {
                        Text("Trip Image")
                            .font(.footnote)
                            .foregroundColor(Color.gray)
                            .padding(.horizontal, 30)
                            .padding(.top, 10)

                        Button(action: {
                            showingPickPhotoActionSheet = true
                        }, label: {
                            Image(uiImage: inputImage)
                                .resizable()
                                .cornerRadius(6)
                                .frame(width: 100, height: 100)
                                .clipped()
                            
                        })
                            .padding(.horizontal, 30)
                            .actionSheet(isPresented: $showingPickPhotoActionSheet) {
                            
                            ActionSheet(title: Text("Photo Picker"), message: Text("Select a new photo"), buttons: [
                                .default(Text("Camera")) {
                                    showingPickFromCameraSheet = true
                                },
                                .default(Text("Album")) {
                                    showingPickFromAlbumSheet = true
                                },
                                .cancel()
                            ])
                        }
                        .sheet(isPresented: $showingPickFromCameraSheet) {
                            
                            print(inputImage)
                            
                        } content: {
                            ImagePickerView(image: $inputImage, sourceType: .camera)
                        }
                        .sheet(isPresented: $showingPickFromAlbumSheet) {
                            
                            print(inputImage)

                        } content: {
                            ImagePickerView(image: $inputImage, sourceType: .photoLibrary)
                        }
                        Divider()
                            .padding(.horizontal, 30)
                    }
                }
                
                Section {
                    VStack(alignment: .leading) {
                        Text("Trip Name")
                            .font(.footnote)
                            .foregroundColor(Color.gray)
                            .padding(.horizontal, 30)
                            .padding(.top, 10)
                        TextField("Trip Name", text: $trip.name)
                            .multilineTextAlignment(.leading)
                            .modifier(Shake(shakes: nameWrong ? 2 : 0))
                            .animation(Animation.linear, value: nameWrong)
                            .padding(.horizontal, 30).padding(.top, 10)
                        Divider()
                            .padding(.horizontal, 30)
                    }
                }
                                    
                Section {
                    VStack(alignment: .leading) {
                        Text("Start Date")
                            .font(.footnote)
                            .foregroundColor(Color.gray)
                            .padding(.horizontal, 30)
                            .padding(.top, 10)
                        DatePicker("Start Date", selection: $trip.start, in: Date()..., displayedComponents: [.date])
                            .modifier(Shake(shakes: startDateWrong ? 2 : 0))
                            .animation(Animation.linear, value: startDateWrong)
                            .padding(.horizontal, 30)
                            .padding(.top, 15)
                        Divider()
                            .padding(.horizontal, 30)
                    }
                }
                
                Section {
                    VStack(alignment: .leading) {
                        Text("End Date")
                            .font(.footnote)
                            .foregroundColor(Color.gray)
                            .padding(.horizontal, 30)
                            .padding(.top, 10)
                        DatePicker("End Date", selection: $trip.end, in: Date()..., displayedComponents: [.date])
                            .modifier(Shake(shakes: endDateWrong ? 2 : 0))
                            .animation(Animation.linear, value: endDateWrong)
                            .padding(.horizontal, 30)
                            .padding(.top, 15)
                        Divider()
                            .padding(.horizontal, 30)
                    }
                }
                
                Section {
                    VStack(alignment: .leading) {
                        Text("Trip City")
                            .font(.footnote)
                            .foregroundColor(Color.gray)
                            .padding(.horizontal, 30)
                            .padding(.top, 10)
                        TextField("Trip City", text: $trip.location)
                            .multilineTextAlignment(.leading)
                            .modifier(Shake(shakes: locationWrong ? 2 : 0))
                            .animation(Animation.linear, value: locationWrong)
                            .padding(.horizontal, 30).padding(.top, 10)
                        Divider()
                            .padding(.horizontal, 30)
                    }
                }
                
                VStack {
                    Spacer().frame(height: 30)
                    Button("Add") {
                        addTrip()
                    }
                    .frame(minWidth: 150, idealWidth: .infinity, maxWidth: .infinity, minHeight: 40, idealHeight: 40, maxHeight: .infinity, alignment: .center)
                    .padding(.vertical, 10)
                    .background(AppThemeColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 30)
                }
            }
        }
        .navigationBarTitle(Text("Add a Trip"))
        .onTapGesture {
            resignFirstResponder()
        }
        .toast(isPresenting: $showAddTripSuccess, duration: 1.5, tapToDismiss: false, offsetY: 0.0) {
            
            AlertToast(displayMode: .hud, type: .complete(AppThemeColor), title: "Add trip success", subTitle: nil, style: .none)
        }
    }
    
    private func addTrip() {
        
        guard !trip.name.isEmpty else {
            withAnimation {
                nameWrong.toggle()
            }
            return
        }

        guard trip.end >= trip.start else {
            withAnimation {
                endDateWrong.toggle()
            }
            return
        }
        
        guard !trip.location.isEmpty else {
            withAnimation {
                locationWrong.toggle()
            }
            return
        }
        
        //save image to sanbox path, and file name by trip id
        let imageName = "\(trip.id).png"
        inputImage.saveAsTripImage(imageName)
        trip.imageURL = imageName
        
        viewmodel.add(trip) { success in
            if success {
                print("add trip into database success")
                self.showAddTripSuccess.toggle()
                presentationMode.wrappedValue.dismiss()
            } else {
                print("add trip into database failed!")
            }
        }
    }
    
    private func resignFirstResponder() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
}

struct Shake: GeometryEffect {
    func effectValue(size: CGSize) -> ProjectionTransform {
            return ProjectionTransform(CGAffineTransform(translationX: -30 * sin(position * 2 * .pi), y: 0))
        }
        
        init(shakes: Int) {
            position = CGFloat(shakes)
        }
        
        var position: CGFloat
        var animatableData: CGFloat {
            get { position }
            set { position = newValue }
        }
}
